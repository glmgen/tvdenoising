#' Univariate total variation denoising
#'
#' Total variation denoising is performed at a fixed tuning parameter value
#' using the linear-time dynamic programming approach of Johnson (2013).
#' Observation weights may be optionally specified.
#'
#' @param y Numeric vector of observations to be denoised.
#' @param lambda Scalar. A non-negative regularization parameter. These will be
#'  rescaled to sum to `length(y)` internally.
#' @param weights Numeric vector of the same length as `y`, containing
#' 	observation weights. The default is `NULL`, which corresponds to unity
#'  weights.
#' @return Denoised observations. A vector the same length as `y`
#'
#' @references Johnson (2013), "A dynamic programming algorithm for the fused
#'  lasso and L0-segmentation."
#' @export
#' @examples
#' y <- c(rnorm(30), rnorm(40, 2), rnorm(30))
#' yhat <- tvdenoising(y, 10)
#' w <- runif(100)
#' yhat2 <- tvdenoising(y, 10, w)
#' plot(y, pch = 16)
#' lines(yhat, col = 2)
#' lines(yhat2, col = 4)
tvdenoising <- function(y, lambda, weights = NULL) {
  if (!is.numeric(y)) {
    stop("`y` must be a numeric vector.")
  }
  if (!is.numeric(lambda)) {
    stop("`lambda` must be a number > 0.")
  }
  if (length(lambda) > 1) {
    stop("`lambda` must be a scalar (have length 1).")
  }
  if (lambda < 0) {
    stop("`lambda` must be non-negative.")
  }
  if (is.null(weights)) return(flsa_dp(y, lambda))
  ## weighted version
  if (!is.numeric(weights)) {
    stop("`weights` must be a numeric vector.")
  }
  n <- length(y)
  if (length(weights) != n) {
    stop("`weights` must have the same length as `y`.")
  }
  weights <- weights / sum(weights) * n
  flsa_dp_weighted(y, lambda, weights)
}
