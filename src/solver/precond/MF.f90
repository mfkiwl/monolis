module mod_monolis_precond_mf
  use mod_monolis_prm
  use mod_monolis_com
  use mod_monolis_mat
  use mod_monolis_fact_mf
  use mod_monolis_matrix_fillin

  implicit none

contains

  subroutine  monolis_precond_mf_setup(monoPRM, monoCOM, monoMAT)
    implicit none
    type(monolis_prm) :: monoPRM
    type(monolis_com) :: monoCOM
    type(monolis_mat) :: monoMAT

    call monolis_precond_mf_init(monoPRM, monoCOM, monoMAT)
    call monolis_init_MF_inner(monoPRM, monoCOM, monoMAT%monoTREE)
    call monolis_fact_MF_inner(monoPRM, monoCOM, monoMAT%monoTREE)
  end subroutine monolis_precond_mf_setup

  subroutine monolis_precond_mf_apply(monoPRM, monoCOM, monoMAT, X, Y)
    implicit none
    type(monolis_prm) :: monoPRM
    type(monolis_com) :: monoCOM
    type(monolis_mat) :: monoMAT
    real(kdouble) :: X(:), Y(:)
    integer(kint) :: i, N, NDOF

    N = monoMAT%N
    NDOF = monoMAT%NDOF
    do i = 1, N*NDOF
      monoMAT%monoTREE%B(i) = X(i)
    enddo
    call monolis_solv_MF_inner(monoPRM, monoCOM, monoMAT%monoTREE)
    do i = 1, N*NDOF
      Y(i) = monoMAT%monoTREE%X(i)
    enddo
  end subroutine monolis_precond_mf_apply

  subroutine monolis_precond_mf_clear(monoPRM, monoCOM, monoMAT)
    implicit none
    type(monolis_prm) :: monoPRM
    type(monolis_com) :: monoCOM
    type(monolis_mat) :: monoMAT

    deallocate(monoMAT%monoTREE%B)
    deallocate(monoMAT%monoTREE%X)
    call monolis_clear_MF_inner(monoPRM, monoCOM, monoMAT%monoTREE)
  end subroutine monolis_precond_mf_clear

  subroutine monolis_precond_mf_init(monoPRM, monoCOM, monoMAT)
    implicit none
    type(monolis_prm) :: monoPRM
    type(monolis_com) :: monoCOM
    type(monolis_mat) :: monoMAT
    integer(kint) :: N, NDOF
    logical :: is_fillin = .true.
    logical :: is_asym = .false.

    N = monoMAT%N
    NDOF = monoMAT%NDOF
    monoMAT%monoTREE%N = monoMAT%N
    monoMAT%monoTREE%NP = monoMAT%NP
    monoMAT%monoTREE%NDOF = monoMAT%NDOF
    allocate(monoMAT%monoTREE%B(N*NDOF))
    allocate(monoMAT%monoTREE%X(N*NDOF))
    monoMAT%monoTREE%B = 0.0d0
    monoMAT%monoTREE%X = 0.0d0
    call monolis_matrix_get_fillin(monoPRM, monoCOM, monoMAT, monoMAT%monoTREE, is_fillin, is_asym)
    call monolis_matrix_copy_with_fillin(monoPRM, monoCOM, monoMAT, monoMAT%monoTREE, is_asym)
  end subroutine monolis_precond_mf_init
end module mod_monolis_precond_mf