/* monolis_vec_util.h */
#ifndef MONOLISVEC_UTIL_H
#define MONOLISVEC_UTIL_H

#ifdef __cplusplus
extern "C" {
#endif

void monolis_vec_copy_I(
  int  n,
  int  n_dof,
  int* x,
  int* y);

void monolis_vec_copy_R(
  int     n,
  int     n_dof,
  double* x,
  double* y);

void monolis_vec_copy_C(
  int              n,
  int              n_dof,
  double _Complex* x,
  double _Complex* y);

#ifdef __cplusplus
}
#endif

#endif
