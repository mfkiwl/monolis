program main
  use mod_monolis_prm
  use mod_monolis_com
  use mod_monolis_mat
  use mod_monolis_util
  use mod_monolis_solve
  use mod_monolis_hash
  implicit none
  type(monolis_prm) :: monoPRM
  type(monolis_com) :: monoCOM
  type(monolis_mat) :: monoMAT
  integer(kind=kint) :: key, val
  logical :: is_pushed, is_exist

  !call monolis_initialize(monoPRM, monoCOM, monoMAT)
  !call monolis_finalize(monoPRM, monoCOM, monoMAT)

end program main
