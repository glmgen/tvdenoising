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
#' @details This function minimizes the univariate total variation denoising
#'   (also called fused lasso) criterion squares criterion
#'   \deqn{
#'   \frac{1}{2} \sum_{i=1}^n (y_i - \theta_i)^2 + 
#'     \lambda \sum_{i=1}^{n-1} |\theta_{i+1} - \theta_i|,
#'   }
#'   over \eqn{\theta}. This is a special structured convex optimization problem
#'   which can be solved in linear time (\eqn{O(n)} operations) using algorithms
#'   based on dynamic programming (Viterbi) or taut string methods. The current
#'   function implements a highly-efficient dynamic programming method developed 
#'   by Johnson (2013).
#'   
#' @references Johnson (2013), "A dynamic programming algorithm for the fused
#'  lasso and L0-segmentation."
#' @export
#' @examples
#' y <- c(rep(0, 50), rep(3, 50)) + rnorm(100)
#' yhat <- tvdenoising(y, 5)
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
    if (length(weights) != length(y) || any(weights <= 0))
      rlang::abort(paste("`weights` must be a positive vector of the same",
                         "length as `y`."))
    
    weights = weights / sum(weights) * length(y)
    return(rcpp_wtvd(y, lambda, weights))
  }
}
