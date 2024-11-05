#' Univariate total variation denoising
#'
#' Total variation denoising is performed at a fixed tuning parameter value
#' using the linear-time dynamic programming approach of Johnson (2013).
#' Observation weights may be optionally specified.
#'
#' @param y Numeric vector of observations to be denoised.
#' @param lambda Scalar. A non-negative regularization parameter.
#' @param weights Numeric vector of the same length as y, containing
#' 	observation weights. The default is `NULL`, which corresponds to unity
#'  weights. These will automatically be forced to sum to `length(y)`.
#' @return Denoised observations.
#'
#' @references Johnson (2013), "A dynamic programming algorithm for the fused
#'  lasso and L0-segmentation."
#' @export
#' @examples
#' y <- c(rnorm(30), rnorm(40, 2), rnorm(30))
#' yhat <- tvdenoising(y, 10)
#' plot(y, pch = 16)
#' lines(yhat, col = 2)
tvdenoising <- function(y, lambda, weights = NULL) {
  if (!is.numeric(y)) stop("`y` must be numeric.")
  if (!is.numeric(lambda)) stop("`lambda` must be numeric.")
  if (length(lambda) != 1L) stop("`lambda` must be a scalar.")
  if (lambda < 0) stop("`lambda` must be non-negative.")
  if (is.null(weights)) {
    return(flsa_dp(y, lambda))
  } else {
    n <- length(y)
    if (!is.numeric(weights)) stop("`weights` must be numeric or NULL.")
    if (length(weights) == 1L) {
      warning("`weights` is a scalar. Using unweighted tvdenoising.")
      return(flsa_dp(y, lambda))
    }
    if (length(weights) != n) stop("`weights` must be the same size as `y`.")
    if (any(weights < 0)) stop("`weights` must be non-negative.")
    weights <- weights / sum(weights) * n
    return(flsa_dp_weighted(y, lambda, weights))
  }
}
