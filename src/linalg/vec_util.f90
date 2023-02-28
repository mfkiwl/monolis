!> ベクトル演算関数群
module mod_monolis_vec_util
  use mod_monolis_utils
  implicit none

contains

  !> @ingroup dev_linalg
  !> ベクトル配列コピー（整数型）
  subroutine monolis_vec_copy_I(n, ndof, X, Y)
    implicit none
    !> 自由度数
    integer(kint) :: n
    !> ブロックサイズ
    integer(kint) :: ndof
    !> ベクトル 1
    integer(kint) :: X(:)
    !> ベクトル 2
    integer(kint) :: Y(:)
    integer(kint) :: i

#ifdef DEBUG
    call monolis_std_debug_log_header("monolis_vec_copy_I")
#endif

!$omp parallel default(none) &
!$omp & shared(X, Y) &
!$omp & firstprivate(n, ndof) &
!$omp & private(i)
!$omp do
    do i = 1, n * ndof
      Y(i) = X(i)
    enddo
!$omp end do
!$omp end parallel
  end subroutine monolis_vec_copy_I

  !> @ingroup dev_linalg
  !> ベクトル配列コピー（実数型）
  subroutine monolis_vec_copy_R(n, ndof, X, Y)
    implicit none
    !> 自由度数
    integer(kint) :: n
    !> ブロックサイズ
    integer(kint) :: ndof
    !> ベクトル 1
    real(kdouble) :: X(:)
    !> ベクトル 2
    real(kdouble) :: Y(:)
    integer(kint) :: i

#ifdef DEBUG
    call monolis_std_debug_log_header("monolis_vec_copy_R")
#endif

!$omp parallel default(none) &
!$omp & shared(X, Y) &
!$omp & firstprivate(n, ndof) &
!$omp & private(i)
!$omp do
    do i = 1, n * ndof
      Y(i) = X(i)
    enddo
!$omp end do
!$omp end parallel
  end subroutine monolis_vec_copy_R

  !> @ingroup dev_linalg
  !> ベクトル配列コピー（複素数型）
  subroutine monolis_vec_copy_C(n, ndof, X, Y)
    implicit none
    !> 自由度数
    integer(kint) :: n
    !> ブロックサイズ
    integer(kint) :: ndof
    !> ベクトル 1
    complex(kdouble) :: X(:)
    !> ベクトル 2
    complex(kdouble) :: Y(:)
    integer(kint) :: i

#ifdef DEBUG
    call monolis_std_debug_log_header("monolis_vec_copy_C")
#endif

!$omp parallel default(none) &
!$omp & shared(X, Y) &
!$omp & firstprivate(n, ndof) &
!$omp & private(i)
!$omp do
    do i = 1, n * ndof
      Y(i) = X(i)
    enddo
!$omp end do
!$omp end parallel
  end subroutine monolis_vec_copy_C

  !> @ingroup dev_linalg
  !> ベクトル和 $z = \alpha * x + y$ （整数型）
  subroutine monolis_vec_AXPY_I(n, ndof, alpha, X, Y, Z)
    implicit none
    !> 自由度数
    integer(kint) :: n
    !> ブロックサイズ
    integer(kint) :: ndof
    !> ベクトル 1
    integer(kint) :: alpha
    !> ベクトル 1
    integer(kint) :: X(:)
    !> ベクトル 2
    integer(kint) :: Y(:)
    !> ベクトル 3
    integer(kint) :: Z(:)
    integer(kint) :: i

#ifdef DEBUG
    call monolis_std_debug_log_header("monolis_vec_AXPY_I")
#endif

!$omp parallel default(none) &
!$omp & shared(X, Y, Z) &
!$omp & firstprivate(n, ndof, alpha) &
!$omp & private(i)
!$omp do
    do i = 1, n * ndof
      Z(i) = alpha*X(i) + Y(i)
    enddo
!$omp end do
!$omp end parallel
  end subroutine monolis_vec_AXPY_I

  !> @ingroup dev_linalg
  !> ベクトル和 $z = \alpha * x + y$ （実数型）
  subroutine monolis_vec_AXPY_R(n, ndof, alpha, X, Y, Z)
    implicit none
    !> 自由度数
    integer(kint) :: n
    !> ブロックサイズ
    integer(kint) :: ndof
    !> ベクトル 1
    real(kdouble) :: alpha
    !> ベクトル 1
    real(kdouble) :: X(:)
    !> ベクトル 2
    real(kdouble) :: Y(:)
    !> ベクトル 3
    real(kdouble) :: Z(:)
    integer(kint) :: i

#ifdef DEBUG
    call monolis_std_debug_log_header("monolis_vec_AXPY_R")
#endif

!$omp parallel default(none) &
!$omp & shared(X, Y, Z) &
!$omp & firstprivate(n, ndof, alpha) &
!$omp & private(i)
!$omp do
    do i = 1, n * ndof
      Z(i) = alpha*X(i) + Y(i)
    enddo
!$omp end do
!$omp end parallel
  end subroutine monolis_vec_AXPY_R

  !> @ingroup dev_linalg
  !> ベクトル和 $z = \alpha * x + y$ （複素数型）
  subroutine monolis_vec_AXPY_C(n, ndof, alpha, X, Y, Z)
    implicit none
    !> 自由度数
    integer(kint) :: n
    !> ブロックサイズ
    integer(kint) :: ndof
    !> ベクトル 1
    complex(kdouble) :: alpha
    !> ベクトル 1
    complex(kdouble) :: X(:)
    !> ベクトル 2
    complex(kdouble) :: Y(:)
    !> ベクトル 3
    complex(kdouble) :: Z(:)
    integer(kint) :: i

#ifdef DEBUG
    call monolis_std_debug_log_header("monolis_vec_AXPY_C")
#endif

!$omp parallel default(none) &
!$omp & shared(X, Y, Z) &
!$omp & firstprivate(n, ndof, alpha) &
!$omp & private(i)
!$omp do
    do i = 1, n * ndof
      Z(i) = alpha*X(i) + Y(i)
    enddo
!$omp end do
!$omp end parallel
  end subroutine monolis_vec_AXPY_C
end module mod_monolis_vec_util