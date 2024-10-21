# tests/testthat/test-tvdenoising.R

test_that("tvdenoising works correctly with no weights", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- 1
  result <- tvdenoising(y, lambda)
  expected_result <- c(2, 2, 3, 5, 8, 13, 20)
  expect_type(result, "double")
  expect_length(result, length(y))
  expect_equal(result, expected_result, tolerance = 1e-6) 
})


test_that("tvdenoising works correctly with weights", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- 1

  weights <- c(1, 3, 3, 2, 5, 6, 2)
  result <- tvdenoising(y, lambda, weights)
  expect_type(result, "double")
  expect_length(result, length(y))
  expected_result <- c(2,2,3,5,8,13,20.5)
  expect_equal(result, expected_result, tolerance = 1e-6) 
})


test_that("tvdenoising with uniform weights 1 matches unweighted version", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- 1
  uniform_weights1 <- rep(1, length(y))  
  result_no_weights <- tvdenoising(y, lambda)
  result_with_weights1 <- tvdenoising(y, lambda, uniform_weights1)
  expect_equal(result_no_weights, result_with_weights1, tolerance = 1e-6)
})

test_that("tvdenoising with uniform weights 2", {
  y <- c(1, 2, 3, 5, 8, 13, 21)
  lambda <- 1
  uniform_weights2 <- rep(2, length(y))  
  expected_result <- c(1.5, 2, 3, 5, 8, 13, 20.5)
  result_with_weights2 <- tvdenoising(y, lambda, uniform_weights2)
  expect_equal(expected_result, result_with_weights2, tolerance = 1e-6)
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


