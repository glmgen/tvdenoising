y <- c(1, 2, 3, 5, 8, 13, 21)
lambda <- 1

test_that("tvdenoising handles various errors", {
  expect_snapshot(error = TRUE, tvdenoising(letters[1:10], 1))

  # lambda errors
  expect_snapshot(error = TRUE, tvdenoising(y, "not a number"))
  expect_snapshot(error = TRUE, tvdenoising(y, c(3, 4)))
  expect_snapshot(error = TRUE, tvdenoising(y, -1))

  # weight errors
  expect_snapshot(error = TRUE, tvdenoising(y, 1, rep("a", length(y))))
  weights <- c(1, 2)  # when weights length does not match y
  expect_snapshot(error = TRUE, tvdenoising(y, 1, weights))
  weights <- seq_along(y)
  weights[3] <- weights[3] * -1
  expect_snapshot(error = TRUE, tvdenoising(y, 1, weights))
})

test_that("tvdenoising works correctly with no weights", {
  result <- tvdenoising(y, lambda)
  expected_result <- c(2, 2, 3, 5, 8, 13, 20)
  expect_type(result, "double")
  expect_length(result, length(y))
  expect_equal(result, expected_result)
  expect_warning(result2 <- tvdenoising(y, lambda, 2))
  expect_equal(result2, expected_result)
})

test_that("tvdenoising works correctly with weights", {
  y <- c(y, 16, 12, 14)
  weights <- c(1, 2, 2, 1, 4, 3, 2, 3, 1, 1)
  weights <- weights / sum(weights) * length(weights)
  result <- tvdenoising(y, lambda, weights)
  expect_type(result, "double")
  expect_length(result, length(y))
  expected_result <- c(7 / 3, 7 / 3, 3, 5, 8, 13, 19, 16, 14, 14)
  expect_equal(result, expected_result)
})

test_that("tvdenoising with uniform weights 1 matches unweighted version", {
  uniform_weights1 <- rep(1, length(y))
  result_no_weights <- tvdenoising(y, lambda)
  result_with_weights1 <- tvdenoising(y, lambda, uniform_weights1)
  expect_equal(result_no_weights, result_with_weights1)
})

test_that("tvdenoising with uniform weights 2", {
  uniform_weights2 <- rep(2, length(y))
  expected_result <- tvdenoising(y, lambda, NULL)
  result_with_weights2 <- tvdenoising(y, lambda, uniform_weights2)
  expect_equal(expected_result, result_with_weights2)
})
