#' Univariate total variation denoising
#'
#' Denoises a sequence of observations by solving the univariate total variation 
#' denoising optimization problem at a given regularization level.
#' 
#' @param y Vector of observations to be denoised.
#' @param lambda Regularization parameter value. Must be >= 0.
#' @param weights Vector of observation weights. The default is `NULL`, which 
#'   corresponds to unity weights. This vector must have the same length as `y`.
#' @return Vector of denoised observations.
#'
#' @references Johnson (2013), "A dynamic programming algorithm for the fused
#'  lasso and L0-segmentation."
#' @export
#' @examples
#' y <- c(rep(0, 50), rep(3, 50)) + rnorm(100)
#' yhat <- tvdenoising(y, lambda)
#' plot(y, pch = 16, col = "gray60")
#' lines(yhat, col = "firebrick", lwd = 2)
tvdenoising <- function(y, lambda, weights = NULL) {
  if (!is.numeric(y)) rlang::abort("`y` must be numeric.")
  if (!is.numeric(lambda)) rlang::abort("`lambda` must be numeric.")
  if (length(lambda) != 1) rlang::abort("`length(lambda)` must be 1.")
  if (lambda < 0) rlang::abort("`lambda` must be nonnegative.")
  if (is.null(weights)) {
    return(rcpp_tvd(y, lambda))
  } 
  else {
    if (!is.numeric(weights)) rlang::abort("`weights` must be numeric.")
    if (length(weights) != length(y) || any(weights < 0))
      rlang::abort(paste("`weights` must be a nonnegative vector of the same",
                         "length as `y`."))
    
    weights = weights / sum(weights) * length(y)
    return(rcpp_wtvd(y, lambda, weights))
  }
}

#' Old implementation of tvdenoising
#' @export
tvdenoising2 <- function(y, lambda, weights = NULL) {
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
