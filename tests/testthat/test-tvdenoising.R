# tests/testthat/test-tvdenoising.R

test_that("tvdenoising works correctly with no weights", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- 1
  result <- tvdenoising(y, lambda)
  expect_type(result, "double")
  expect_length(result, length(y))
  
  # Check if the output is not equal to the input, implying denoising occurred
  expect_false(all(result == y))
})

test_that("tvdenoising works correctly with weights", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- 1
  
  set.seed(123) 
  weights <- runif(length(y), min = 0.5, max = 1000)
  result <- tvdenoising(y, lambda, weights)
  expect_type(result, "double")
  expect_length(result, length(y))
  
  # Check if the output is not equal to the input, implying denoising occurred
  expect_false(all(result == y))
})

test_that("tvdenoising with uniform weights matches unweighted version", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- 1
  uniform_weights <- rep(1, length(y))  
  
  result_no_weights <- tvdenoising(y, lambda)
  result_with_weights <- tvdenoising(y, lambda, uniform_weights)

  expect_equal(result_no_weights, result_with_weights)
})

test_that("tvdenoising handles incorrect input properly", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- "not a number"
  
  # when lambda is not numeric
  expect_error(tvdenoising(y, lambda))
  
  # when weights length does not match y
  weights <- c(1, 2)
  expect_error(tvdenoising(y, 1, weights))
})


