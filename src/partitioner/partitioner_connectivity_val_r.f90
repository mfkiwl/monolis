program monolis_partitioner_distval
  use mod_monolis_mesh
  use mod_monolis_io
  use mod_monolis_io_arg
  implicit none
  integer(kint) :: n_domain, nelem, ndof
  type(monolis_mesh), allocatable :: mesh(:)
  real(kdouble), allocatable :: val(:,:)
  character :: fname*100, label*100

  call monolis_get_part_bc_arg(n_domain, fname)

  call monolis_input_mesh_distval_r(fname, nelem, ndof, val, label)

  allocate(mesh(n_domain))

  call monolis_par_input_connectivity_id(n_domain, mesh)

  call monolis_par_output_connectivity_val_r(n_domain, mesh, fname, ndof, val, label)

end program monolis_partitioner_distval
