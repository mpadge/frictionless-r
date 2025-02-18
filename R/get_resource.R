#' Get a Data Resource
#'
#' Returns a [Data Resource](https://specs.frictionlessdata.io/data-resource/)
#' from a Data Package, i.e. the content of one of the described `resources`.
#'
#' @inheritParams read_resource
#' @return List describing a Data Resource, with new property `read_from` to
#'   indicate how data should be read.
#'   If present, `path` will be updated to contain the full path(s).
#' @family edit functions
#' @noRd
#' @examples
#' # Load the example Data Package
#' package <- example_package
#'
#' # Get the resource "observations"
#' resource <- frictionless:::get_resource(package, "observations")
#' str(resource)
get_resource <- function(package, resource_name) {
  # Check package
  check_package(package)

  # Check resource
  resource_names <- resources(package)
  assertthat::assert_that(
    resource_name %in% resource_names,
    msg = glue::glue(
      "Can't find resource `{resource_name}` in {resource_names_collapse}.",
      resource_names_collapse = glue::glue_collapse(
        glue::backtick(resource_names),
        sep = ", "
      )
    )
  )

  # Get resource
  resource <- purrr::keep(package$resources, ~ .x$name == resource_name)[[1]]

  # Check path(s) to file(s)
  # https://specs.frictionlessdata.io/data-resource/#data-location
  assertthat::assert_that(
    !is.null(resource$path) | !is.null(resource$data),
    msg = glue::glue(
      "Resource `{resource_name}` must have property `path` or `data`."
    )
  )

  # Assign read_from property (based on path, then df, then data)
  if (length(resource$path) != 0) {
    if (all(is_url(resource$path))) {
      resource$read_from <- "url"
    } else {
      resource$read_from <- "path"
    }
    # Expand paths to full paths, check if file exists and check path safety,
    # unless those paths were willingly added by user in add_resource()
    if (replace_null(attributes(resource)$path, "") != "added") {
      resource$path <- purrr::map_chr(
        resource$path, ~ check_path(.x, package$directory, safe = TRUE)
      )
    }
  } else if (is.data.frame(resource$data)) {
    resource$read_from <- "df"
  } else if (!is.null(resource$data)) {
    resource$read_from <- "data"
  }

  resource
}
