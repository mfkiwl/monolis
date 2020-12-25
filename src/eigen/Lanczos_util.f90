module mod_monolis_eigen_lanczos_util
  use mod_monolis_prm
  use mod_monolis_com
  use mod_monolis_mat
  use mod_monolis_linalg

  implicit none

contains

  subroutine lanczos_initialze(n, q)
    implicit none
    integer(kint) :: i, n
    real(kdouble) :: q(:), norm

    norm = 0.0d0
    do i = 1, n
      q(i) = dble(i)
      norm = norm + q(i)*q(i)
    enddo

    norm = 1.0d0/dsqrt(norm)
    do i = 1, n
      q(i) = q(i)*norm
    enddo
  end subroutine lanczos_initialze

  subroutine monolis_gram_schmidt(monoPRM, monoCOM, monoMAT, iter, q, p)
    implicit none
    type(monolis_prm) :: monoPRM
    type(monolis_com) :: monoCOM
    type(monolis_mat) :: monoMAT
    integer(kint) :: i, j, iter, N, NDOF
    real(kdouble) :: q(:,0:), p(:), norm

    N    = monoMAT%N
    NDOF = monoMAT%NDOF

    do i = 1, iter-1
      call monolis_inner_product_R(monoCOM, N, NDOF, p, q(:,i), norm, monoPRM%tdotp, monoPRM%tcomm_dotp)

      do j = 1, N*NDOF
        p(j) = p(j) - norm*q(j,i)
      enddo
    enddo
  end subroutine monolis_gram_schmidt

  subroutine monolis_get_smallest_eigen_pair_from_3x3(iter, Sa, Sb, lambda, coef)
    implicit none
    integer(kint) :: iter, it, lda, ldb, info, iw, N, dof
    real(kdouble) :: Sa(3,3), Sb(3,3), lambda, coef(3), e_value(3), rw(8)

    dof = 3
    if(iter == 1) dof = 2

    it = 1
    N = dof
    lda = dof
    ldb = dof
    iw = 8
    call dsygv(it, "V", "L", N, Sa(1:dof,1:dof), lda, Sb(1:dof,1:dof), ldb, e_value(1:dof), rw, iw, info)

    lambda = e_value(1)
    coef(1) = Sa(1,1)
    coef(2) = Sa(2,1)
    coef(3) = Sa(3,1)

!>    N = dof
!>    M = dof
!>    lda = dof
!>    inv = Sb
!>    call dgetrf(N, M, inv(1:dof,1:dof), lda, ipv(1:dof), info)
!>
!>    N = dof
!>    lda = dof
!>    iw = dof
!>    call dgetri(N, inv(1:dof,1:dof), lda, ipv, rw(1:dof), iw, info)
!>    mat(1:dof,1:dof) = matmul(inv(1:dof,1:dof), Sa(1:dof,1:dof))
  end subroutine monolis_get_smallest_eigen_pair_from_3x3

  subroutine monolis_get_eigen_pair_from_tridiag(iter, alpha_t, beta_t, q, e_value, e_mode)
    implicit none
    integer(kint) :: iter, i, n, m, iu, il, ldz, info, liwork, lwork
    real(kdouble) :: alpha_t(:), beta_t(:), q(:,0:), e_value(:), e_mode(:,:)
    real(kdouble) :: vl, vu, abstol
    integer(kint), allocatable :: isuppz(:), idum(:)
    real(kdouble), allocatable :: alpha(:), beta(:), rdum(:), e_mode_t(:,:)

    !> DSTEVR
    allocate(alpha(iter), source = 0.0d0)
    allocate(beta (max(1,iter-1)), source = 0.0d0)
    allocate(isuppz(2*iter), source = 0)
    allocate(idum(10*iter), source = 0)
    allocate(rdum(20*iter), source = 0.0d0)
    allocate(e_mode_t(iter,iter), source = 0.0d0)

    alpha = alpha_t(1:iter)
    beta = beta_t(2:max(1,iter-1)+1)

    vl = 0.0d0
    vu = 0.0d0
    il = 0
    iu = 0
    abstol = 1.0d-8
    n = iter
    m = iter
    ldz = iter
    lwork = 20*iter
    liwork = 10*iter

    call dstevr("V", "A", n, alpha, beta, vl, vu, il, iu, abstol, m, e_value, &
      e_mode_t, ldz, isuppz, rdum, lwork, idum, liwork, info)
    if(info /= 0) stop "monolis_get_eigen_pair_from_tridiag"

    e_mode(:,1:iter) = matmul(q(:,1:iter), e_mode_t)

    deallocate(alpha)
    deallocate(beta)
    deallocate(isuppz)
    deallocate(idum)
    deallocate(e_mode_t)
    deallocate(rdum)
  end subroutine monolis_get_eigen_pair_from_tridiag
end module mod_monolis_eigen_lanczos_util
