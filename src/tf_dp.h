#ifndef TF_DP_H
#define TF_DP_H

/* Dynamic programming routines */
void tf_dp (int n, double *y, double lam, double *beta);
void tf_dp_weight (int n, double *y, double *w, double lam, double *beta);

#endif
