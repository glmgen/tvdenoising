test_that("Simple unweighted", {
  y = c(1, 2, 3, 5, 8, 13, 21)
  lambda = 1
  result = tvdenoising(y, lambda)
  expected_result = c(2, 2, 3, 5, 8, 13, 20)
  expect_equal(result, expected_result)
})

test_that("Simple weighted", {
  y = c(1, 2, 3, 5, 8, 13, 21, 16, 12, 14)
  weights = c(1, 2, 2, 1, 4, 3, 2, 3, 1, 1)
  lambda = 1
  result = tvdenoising(y, lambda, weights)
  expected_result = c(7 / 3, 7 / 3, 3, 5, 8, 13, 19, 16, 14, 14)
  expect_equal(result, expected_result)
})

test_that("Uniform weights check", {
  y = c(1, 2, 3, 5, 8, 13, 21)
  lambda = 1
  uniform_weights1 = rep(1, length(y))
  uniform_weights2 = rep(2, length(y))
  result_no_weights = tvdenoising(y, lambda)
  result_with_weights1 = tvdenoising(y, lambda, uniform_weights1)
  result_with_weights2 = tvdenoising(y, lambda, uniform_weights2)
  expect_equal(result_no_weights, result_with_weights1)
  expect_equal(result_no_weights, result_with_weights2)
})

test_that("No regularization check", {
  y = c(1, 2, 3, 5, 8, 13, 21)
  result = tvdenoising(y, 0)
  expect_equal(result, y)
})

test_that("genlasso check", {
  saved = readRDS(test_path("genlasso-dat.rds"))
  lambda = saved$lambda
  result1 = saved$result1
  result2 = tvdenoising(saved$y, lambda)
  expect_equal(result1, result2)
})
