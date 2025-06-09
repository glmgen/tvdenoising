#include <Rcpp.h>
using namespace Rcpp;

void wtvd(int n, double *y, double lambda, double *w, double *theta) {
  /* Take care of a few trivial cases */
  if (n == 0) return;
  if (n == 1 || lambda == 0) {
    for (int i = 0; i < n; i++) theta[i] = y[i];
    return;
  }

  double *x = new double[2*n];
  double *a = new double[2*n];
  double *b = new double[2*n];
  double *tm = new double[n-1];
  double *tp = new double[n-1];

  int l;
  int r;
  int lo;
  int hi;
  double afirst;
  double bfirst;
  double alast;
  double blast;
  double alo;
  double blo;
  double ahi;
  double bhi;

  /* We step through the first iteration manually */
  tm[0] = -lambda/w[0]+y[0];
  tp[0] = lambda/w[0]+y[0];
  l = n-1;
  r = n;
  x[l] = tm[0];
  x[r] = tp[0];
  a[l] = w[0];
  b[l] = -w[0]*y[0]+lambda;
  a[r] = -w[0];
  b[r] = w[0]*y[0]+lambda;
  afirst = w[1];
  bfirst = -w[1]*y[1]-lambda;
  alast = -w[1];
  blast = w[1]*y[1]-lambda;

  /* Now step through iterations 2 through n-1 */
  for (int k = 1; k < n-1; k++) {
    /* Compute lo: step up from l until the
       derivative is greater than -lambda */
    alo = afirst;
    blo = bfirst;
    for (lo=l; lo<=r; lo++) {
      if (alo*x[lo]+blo > -lambda) break;
      alo += a[lo];
      blo += b[lo];
    }

    /* Compute hi: step down from r until the
       derivative is less than lambda */
    ahi = alast;
    bhi = blast;
    for (hi = r; hi >= lo; hi--) {
      if (-ahi*x[hi]-bhi < lambda) break;
      ahi += a[hi];
      bhi += b[hi];
    }

    /* Compute the negative knot */
    tm[k] = (-lambda-blo)/alo;
    l = lo-1;
    x[l] = tm[k];

    /* Compute the positive knot */
    tp[k] = (lambda+bhi)/(-ahi);
    r = hi+1;
    x[r] = tp[k];

    /* Update a and b */
    a[l] = alo;
    b[l] = blo+lambda;
    a[r] = ahi;
    b[r] = bhi+lambda;
    afirst = w[k+1];
    bfirst = -w[k+1]*y[k+1]-lambda;
    alast = -w[k+1];
    blast = w[k+1]*y[k+1]-lambda;
  }

  /* Compute the last coefficient: this is where
     the function has zero derivative */
  alo = afirst;
  blo = bfirst;
  for (lo = l; lo <= r; lo++) {
    if (alo*x[lo]+blo > 0) break;
    alo += a[lo];
    blo += b[lo];
  }
  theta[n-1] = -blo/alo;

  /* Compute the rest of the coefficients, by the
     back-pointers */
  for (int k = n-2; k >= 0; k--) {
    if (theta[k+1] > tp[k]) theta[k] = tp[k];
    else if (theta[k+1] < tm[k]) theta[k] = tm[k];
    else theta[k] = theta[k+1];
  }

  delete[] x;
  delete[] a;
  delete[] b;
  delete[] tm;
  delete[] tp;
}

// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
NumericVector rcpp_wtvd(NumericVector y, double lambda, NumericVector weights) {
  int n = y.size();
  NumericVector theta(n);
  wtvd(n, y.begin(), lambda, weights.begin(), theta.begin());
  return theta;
}
