
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tvdenoising

<!-- badges: start -->
[![R-CMD-check](https://github.com/glmgen/tvdenoising/actions/workflows/R-CMD-check.yaml/badge.svg?branch=xli-branch)](https://github.com/glmgen/tvdenoising/actions/workflows/R-CMD-check.yaml?branch=xli-branch)
<!-- badges: end -->



This package provides an `R` frontend to a `C` implementation of
linear-time univariate total variation denoising via dynamic programming
(Johnson 2013).

## Installation

You can install the development version of tvdenoising from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("glmgen/tvdenoising")
```

## Example

``` r
library(tvdenoising)
y <- c(rnorm(30), rnorm(40, 2), rnorm(30))
yhat <- tvdenoising(y, 10)
plot(y, pch = 16)
lines(yhat, col = 2)
```

<img src="man/figures/README-example-1.png" width="100%" />
