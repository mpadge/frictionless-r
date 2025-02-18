
<!-- README.md is generated from README.Rmd. Please edit that file -->

# frictionless

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/frictionless)](https://CRAN.R-project.org/package=frictionless)
[![CRAN
checks](https://badges.cranchecks.info/worst/frictionless.svg)](https://cran.r-project.org/web/checks/check_results_frictionless.html)
[![R-CMD-check](https://github.com/frictionlessdata/frictionless-r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/frictionlessdata/frictionless-r/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/frictionlessdata/frictionless-r/branch/main/graph/badge.svg)](https://app.codecov.io/gh/frictionlessdata/frictionless-r/)
[![repo
status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![rOpenSci](https://badges.ropensci.org/495_status.svg)](https://github.com/ropensci/software-review/issues/495)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5815355.svg)](https://doi.org/10.5281/zenodo.5815355)
<!-- badges: end -->

Frictionless is an R package to read and write Frictionless Data
Packages. A [Data
Package](https://specs.frictionlessdata.io/data-package/) is a simple
container format and standard to describe and package a collection of
(tabular) data. It is typically used to publish
[FAIR](https://www.go-fair.org/fair-principles/) and open datasets.

To get started, see:

-   [Get
    started](https://docs.ropensci.org/frictionless/articles/frictionless.html):
    an introduction to the package’s main functionalities.
-   [Function
    reference](https://docs.ropensci.org/frictionless/reference/index.html):
    overview of all functions.

## Installation

Install the latest released version from CRAN:

``` r
install.packages("frictionless")
```

Or the development version from
[GitHub](https://github.com/frictionlessdata/frictionless-r) or
[R-universe](https://ropensci.r-universe.dev):

``` r
# install.packages("devtools")
devtools::install_github("frictionlessdata/frictionless-r")

# Or rOpenSci R-universe
install.packages("frictionless", repos = "https://ropensci.r-universe.dev")
```

## Usage

With frictionless you can **read** data from a Data Package (local or
remote) into your R environment. Here we read bird GPS tracking data
from a Data Package published on
[Zenodo](https://doi.org/10.5281/zenodo.5879096):

``` r
library(frictionless)

# Read the datapackage.json file
# This gives you access to all Data Resources of the Data Package without 
# reading them, which is convenient and fast.
package <- read_package("https://zenodo.org/record/5879096/files/datapackage.json")
#> Please make sure you have the right to access data from this Data Package for your intended use.
#> Follow applicable norms or requirements to credit the dataset and its authors.
#> For more information, see https://doi.org/10.5281/zenodo.5879096

# List resources
resources(package)
#> [1] "reference-data" "gps"            "acceleration"

# Read data from the resource "gps"
# This will return a single data frame, even though the data are split over 
# multiple zipped CSV files.
read_resource(package, "gps")
#> # A tibble: 73,047 × 21
#>    event-i…¹ visible timestamp           locat…² locat…³ bar:b…⁴ exter…⁵ gps:d…⁶
#>        <dbl> <lgl>   <dttm>                <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
#>  1   1.43e10 TRUE    2018-05-25 16:11:37    4.25    51.3      NA    32.5     2  
#>  2   1.43e10 TRUE    2018-05-25 16:16:41    4.25    51.3      NA    32.8     2.1
#>  3   1.43e10 TRUE    2018-05-25 16:21:29    4.25    51.3      NA    34.1     2.1
#>  4   1.43e10 TRUE    2018-05-25 16:26:28    4.25    51.3      NA    34.5     2.2
#>  5   1.43e10 TRUE    2018-05-25 16:31:21    4.25    51.3      NA    34.1     2.2
#>  6   1.43e10 TRUE    2018-05-25 16:36:09    4.25    51.3      NA    32.5     2.2
#>  7   1.43e10 TRUE    2018-05-25 16:40:57    4.25    51.3      NA    32.1     2.2
#>  8   1.43e10 TRUE    2018-05-25 16:45:55    4.25    51.3      NA    33.3     2.1
#>  9   1.43e10 TRUE    2018-05-25 16:50:49    4.25    51.3      NA    32.6     2.1
#> 10   1.43e10 TRUE    2018-05-25 16:55:36    4.25    51.3      NA    31.7     2  
#> # … with 73,037 more rows, 13 more variables: `gps:satellite-count` <dbl>,
#> #   `gps-time-to-fix` <dbl>, `ground-speed` <dbl>, heading <dbl>,
#> #   `height-above-msl` <dbl>, `location-error-numerical` <dbl>,
#> #   `manually-marked-outlier` <lgl>, `vertical-error-numerical` <dbl>,
#> #   `sensor-type` <chr>, `individual-taxon-canonical-name` <chr>,
#> #   `tag-local-identifier` <chr>, `individual-local-identifier` <chr>,
#> #   `study-name` <chr>, and abbreviated variable names ¹​`event-id`, …
```

You can also create your own Data Package, add data and **write** it to
disk:

``` r
# Create a Data Package and add the "iris" data frame as a resource
my_package <-
  create_package() %>%
  add_resource(resource_name = "iris", data = iris)

# Write the Data Package to disk
my_package %>%
  write_package("my_directory")
```

For more functionality, see [get
started](https://docs.ropensci.org/frictionless/articles/frictionless.html)
or the [function
reference](https://docs.ropensci.org/frictionless/reference/index.html).

## frictionless vs datapackage.r

[datapackage.r](https://CRAN.R-project.org/package=datapackage.r) is an
alternative R package to work with Data Packages. It has an
object-oriented design (using a `Package` class) and offers validation.
frictionless on the other hand allows you to quickly read and write Data
Packages to and from data frames, getting out of the way for the rest of
your analysis. It is designed to be lightweight, follows
[tidyverse](https://www.tidyverse.org/) principles and supports piping.

## Meta

-   We welcome
    [contributions](https://docs.ropensci.org/frictionless/CONTRIBUTING.html)
    including bug reports.
-   License: MIT
-   Get [citation
    information](https://docs.ropensci.org/frictionless/authors.html#citation)
    for frictionless in R doing `citation("frictionless")`.
-   Please note that this project is released with a [Contributor Code
    of
    Conduct](https://frictionlessdata.io/work-with-us/code-of-conduct/).
    By participating in this project you agree to abide by its terms.
