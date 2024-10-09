#include <Rcpp.h>

extern "C"{
  #include "tf_dp.h"
}

using Rcpp::NumericVector;

// [[Rcpp::interfaces(r, cpp)]]

//' Univariate total variation denoising
//'
//' Total variation denoising is performed at a fixed tuning parameter value
//' using the linear-time dynamic programming approach of Johnson (2013).
//'
//' @param y Numeric vector of observations.
//' @param lambda Regularization parameter.
//' @return Numeric vector of the same length as y, containing denoised
//' 	observations.
//' @keywords internal
// [[Rcpp::export]]
NumericVector flsa_dp(NumericVector y, double lambda) {
  int n = y.size();
  NumericVector theta(n);

  tf_dp(n, y.begin(), lambda, theta.begin());
  return theta;
}

//' Weighted univariate total variation denoising
//'
//' Total variation denoising is performed at a fixed tuning parameter
//' value using the linear-time dynamic programming approach of Johnson
//' (2013), subject to observation weights
//'
//' @param y Numeric vector of observations.
//' @param lambda Regularization parameter.
//' @param weights Numeric vector of the same length as y, containing
//'		observation weights.
//' @return Numeric vector of the same length as y, containing denoised
//' 	observations.
//' @keywords internal
// [[Rcpp::export]]
NumericVector flsa_dp_weighted(NumericVector y, double lambda,
    NumericVector weights) {
  int n = y.size();
  NumericVector theta(n);

  tf_dp_weight(n, y.begin(), weights.begin(), lambda, theta.begin());
  return theta;
}

