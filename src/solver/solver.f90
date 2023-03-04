!> 線形ソルバモジュール
module mod_monolis_solve
  use mod_monolis_utils
  use mod_monolis_def_mat
  use mod_monolis_def_struc
  use mod_monolis_solver_CG
  use mod_monolis_solver_BiCGSTAB
  use mod_monolis_solver_COCG

  implicit none

contains

  !> 線形ソルバ関数
  subroutine monolis_solve(monolis, B, X)
    implicit none
    !> monolis 構造体
    type(monolis_structure) :: monolis
    !> 右辺ベクトル
    real(kdouble) :: B(:)
    !> 解ベクトル
    real(kdouble) :: X(:)

    call monolis_set_RHS(monolis%MAT, B)

    call monolis_set_initial_solution(monolis%MAT, X)

    !call monolis_set_initial_comm(monolis%COM, monolis%MAT)

    call monolis_solve_main(monolis%PRM, monolis%COM, monolis%MAT, monolis%PREC)

    call monolis_get_solution(monolis%MAT, X)
  end subroutine monolis_solve

  !> 線形ソルバ関数（メイン関数）
  subroutine monolis_solve_main(monoPRM, monoCOM, monoMAT, monoPREC)
    implicit none
    !> パラメータ構造体
    type(monolis_prm) :: monoPRM
    !> 通信テーブル構造体
    type(monolis_com) :: monoCOM
    !> 行列構造体
    type(monolis_mat) :: monoMAT
    !> 前処理構造体
    type(monolis_mat) :: monoPREC

    !call monolis_timer_initialize(monoPRM, monoCOM)
    !call monolis_check_diagonal(monoPRM, monoMAT)
    !call monolis_reorder_matrix_fw(monoPRM, monoCOM, monoCOM_reorder, monoMAT, monoMAT_reorder)
    !call monolis_scaling_fw(monoPRM, monoCOM_reorder, monoMAT_reorder)
    !call monolis_precond_setup(monoPRM, monoCOM_reorder, monoMAT_reorder)
    call monolis_solver(monoPRM, monoCOM, monoMAT, monoPREC)
    !call monolis_precond_clear(monoPRM, monoCOM_reorder, monoMAT_reorder)
    !call monolis_scaling_bk(monoPRM, monoCOM_reorder, monoMAT_reorder)
    !call monolis_reorder_matrix_bk(monoPRM, monoCOM_reorder, monoMAT_reorder, monoMAT)
    !call monolis_timer_finalize(monoPRM, monoCOM)
  end subroutine monolis_solve_main

  subroutine monolis_solver(monoPRM, monoCOM, monoMAT, monoPREC)
    implicit none
    !> パラメータ構造体
    type(monolis_prm) :: monoPRM
    !> 通信テーブル構造体
    type(monolis_com) :: monoCOM
    !> 行列構造体
    type(monolis_mat) :: monoMAT
    !> 前処理構造体
    type(monolis_mat) :: monoPREC

!    if(monoPRM%is_debug) call monolis_std_debug_log_header("monolis_solver v0.0.0")

!    if(monoPRM%show_summary .and. monoCOM%my_rank == 0) write(*,"(a)")" ** monolis solver: "// &
!    & trim(monolis_str_iter(monoPRM%method))//", prec: "//trim(monolis_str_prec(monoPRM%precond))

    select case(monoPRM%Iarray(monolis_prm_I_method))
      case (monolis_iter_CG)
        call monolis_solver_CG(monoPRM, monoCOM, monoMAT, monoPREC)

      case (monolis_iter_BiCGSTAB)
        call monolis_solver_BiCGSTAB(monoPRM, monoCOM, monoMAT, monoPREC)

      !case (monolis_iter_BiCGSTAB_noprec)
      !  call monolis_solver_BiCGSTAB_noprec(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_GropCG)
      !  call monolis_solver_GropCG(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_PipeCG)
      !  call monolis_solver_PipeCG(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_PipeCR)
      !  call monolis_solver_PipeCR(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_CABiCGSTAB_noprec)
      !  call monolis_solver_CABiCGSTAB_noprec(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_PipeBiCGSTAB)
      !  call monolis_solver_PipeBiCGSTAB(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_PipeBiCGSTAB_noprec)
      !  call monolis_solver_PipeBiCGSTAB_noprec(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_SOR)
      !  call monolis_solver_SOR(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_IR)
      !  call monolis_solver_IR(monoPRM, monoCOM, monoMAT)

      !case (monolis_iter_GMRES)
      !  call monolis_solver_GMRES(monoPRM, monoCOM, monoMAT)

      case (monolis_iter_COCG)
        call monolis_solver_COCG(monoPRM, monoCOM, monoMAT, monoPREC)
    end select
  end subroutine monolis_solver

end module mod_monolis_solve
