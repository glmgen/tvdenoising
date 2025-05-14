#ifndef TF_DP_H
#define TF_DP_H

/* Dynamic programming routines */
void tf_dp (unsigned int n, double *y, double lam, double *beta);
void tf_dp_weight (unsigned int n, double *y, double *w, double lam, double *beta);

#endif
