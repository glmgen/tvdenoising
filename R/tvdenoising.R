#' Univariate total variation denoising
#'
#' Total variation denoising is performed at a fixed tuning parameter value
#' using the linear-time dynamic programming approach of Johnson (2013).
#' Observation weights may be optionally specified.
#' 
#' @param y Numeric vector of observations to be denoised.
#' @param lambda Regularization parameter.
#' @param weights Numeric vector of the same length as y, containing
#' 	observation weights.  The default is `NULL`, which corresponds to unity
#'  weights.
#' @return Denoised observations.
#'
#' @references Johnson (2013), "A dynamic programming algorithm for the fused
#'  lasso and L0-segmentation."
#' @export
tvdenoising <- function(y, lambda, weights=NULL) {
  stopifnot(is.numeric(y))
  stopifnot(is.numeric(lambda) & (length(lambda) == 1))
  if (is.null(weights)) {
    return(flsa_dp(y, lambda))
  } else {
    stopifnot(is.numeric(weights))
    stopifnot(length(weights) == length(y))
    return(flsa_dp_weighted(y, lambda, weights))
  }
}
