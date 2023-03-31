program main
  use mod_monolis
  use mod_gedatsu
  implicit none
  integer(kint) :: iter, prec

  call monolis_global_initialize()

  call monolis_std_log_string("monolis_solver_parallel_test")

  call monolis_solver_parallel_R_test()

  call monolis_solver_parallel_C_test()

  call monolis_global_finalize()

  contains

  subroutine monolis_solver_parallel_R_test()
    implicit none
    type(monolis_structure) :: mat !> 疎行列変数
    integer(kint) :: n_node, n_elem, n_base, n_id
    integer(kint) :: n_coef, eid(2)
    integer(kint) :: i
    real(kdouble) :: val
    character(monolis_charlen) :: fname
    integer(kint), allocatable :: elem(:,:), global_eid(:)
    real(kdouble), allocatable :: coef(:), node(:,:)
    real(kdouble), allocatable :: a(:), b(:), c(:)

    fname = monolis_get_global_input_file_name("parted.0", "node.dat")
    call monolis_input_node(fname, n_node, node)

    fname = monolis_get_global_input_file_name("parted.0", "elem.dat")
    call monolis_input_elem(fname, n_elem, n_base, elem)

    if(monolis_mpi_get_global_comm_size() > 1)then
      fname = monolis_get_global_input_file_name("parted.0", "elem.dat.id")
      call monolis_input_global_id(fname, n_id, global_eid)
    else
      call monolis_alloc_I_1d(global_eid, n_elem)
      do i = 1, n_elem
        global_eid(i) = i
      enddo
    endif

    call monolis_initialize(mat)

    call monolis_get_nonzero_pattern_by_simple_mesh_R(mat, n_node, 2, 1, n_elem, elem)

    open(20, file = "coef.dat", status = "old")
      read(20,*) n_coef
      call monolis_alloc_R_1d(coef, n_coef)
      do i = 1, n_coef
        read(20,*) coef(i)
      enddo
    close(20)

    do i = 1, n_elem
      eid = elem(:,i)
      val = coef(global_eid(i))
      if(eid(1) == eid(2))then
        call monolis_add_scalar_to_sparse_matrix_R(mat, eid(1), eid(2), 1, 1, val)
      else
        call monolis_add_scalar_to_sparse_matrix_R(mat, eid(1), eid(2), 1, 1, val)
        call monolis_add_scalar_to_sparse_matrix_R(mat, eid(2), eid(1), 1, 1, val)
      endif
    enddo

    call monolis_alloc_R_1d(a, n_node)
    call monolis_alloc_R_1d(b, n_node)
    call monolis_alloc_R_1d(c, n_node)

    a = 1.0d0

    call monolis_matvec_product_R(mat, a, c)

    call monolis_set_maxiter(mat, 1000)
    call monolis_set_tolerance(mat, 1.0d-8)
    call monolis_show_timelog(mat, .true.)
    call monolis_show_iterlog(mat, .true.)
    call monolis_show_summary(mat, .true.)

    do iter = 1, 8
    do prec = 0, 2
      a = 0.0d0
      b = c

      call monolis_set_method(mat, iter)
      call monolis_set_precond(mat, prec)

      call monolis_solve_R(mat, b, a)

      call monolis_mpi_global_barrier();

      b = 1.0d0

      call monolis_test_check_eq_R("monolis_solver_parallel_R_test", a, b)

      call monolis_mpi_global_barrier();
    enddo
    enddo

    call monolis_finalize(mat)
  end subroutine monolis_solver_parallel_R_test

  subroutine monolis_solver_parallel_C_test()
    implicit none
    type(monolis_structure) :: mat !> 疎行列変数
    integer(kint) :: n_node, n_elem, n_base, n_id
    integer(kint) :: n_coef, eid(2)
    integer(kint) :: i
    real(kdouble) :: r
    complex(kdouble) :: val
    character(monolis_charlen) :: fname
    integer(kint), allocatable :: elem(:,:), global_eid(:)
    real(kdouble), allocatable :: coef(:), node(:,:)
    complex(kdouble), allocatable :: a(:), b(:), c(:)

    fname = monolis_get_global_input_file_name("parted.0", "node.dat")
    call monolis_input_node(fname, n_node, node)

    fname = monolis_get_global_input_file_name("parted.0", "elem.dat")
    call monolis_input_elem(fname, n_elem, n_base, elem)

    if(monolis_mpi_get_global_comm_size() > 1)then
      fname = monolis_get_global_input_file_name("parted.0", "elem.dat.id")
      call monolis_input_global_id(fname, n_id, global_eid)
    else
      call monolis_alloc_I_1d(global_eid, n_elem)
      do i = 1, n_elem
        global_eid(i) = i
      enddo
    endif

    call monolis_initialize(mat)

    call monolis_get_nonzero_pattern_by_simple_mesh_C(mat, n_node, 2, 1, n_elem, elem)

    open(20, file = "coef.dat", status = "old")
      read(20,*) n_coef
      call monolis_alloc_R_1d(coef, n_coef)
      do i = 1, n_coef
        read(20,*) coef(i)
      enddo
    close(20)

    do i = 1, n_elem
      eid = elem(:,i)
      r = coef(global_eid(i))
      val = complex(r, r)
      if(eid(1) == eid(2))then
        call monolis_add_scalar_to_sparse_matrix_C(mat, eid(1), eid(2), 1, 1, val)
      else
        call monolis_add_scalar_to_sparse_matrix_C(mat, eid(1), eid(2), 1, 1, val)
        call monolis_add_scalar_to_sparse_matrix_C(mat, eid(2), eid(1), 1, 1, val)
      endif
    enddo

    call monolis_alloc_C_1d(a, n_node)
    call monolis_alloc_C_1d(b, n_node)
    call monolis_alloc_C_1d(c, n_node)

    a = (1.0d0, 1.0d0)

    call monolis_matvec_product_C(mat, a, c)

    call monolis_set_maxiter(mat, 1000)
    call monolis_set_tolerance(mat, 1.0d-8)
    call monolis_show_timelog(mat, .true.)
    call monolis_show_iterlog(mat, .true.)
    call monolis_show_summary(mat, .true.)

    do iter = 9, 9
    do prec = 0, 2
      a = (0.0d0, 0.0d0)
      b = c

      call monolis_set_method(mat, iter)
      call monolis_set_precond(mat, prec)

      call monolis_solve_C(mat, b, a)

      call monolis_mpi_global_barrier();

      b = (1.0d0, 1.0d0)

      call monolis_test_check_eq_C("monolis_solver_parallel_C_test", a, b)

      call monolis_mpi_global_barrier();
    enddo
    enddo

    call monolis_finalize(mat)
  end subroutine monolis_solver_parallel_C_test
end program main
