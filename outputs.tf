output "ip_address" {
  value = {
    for vm in libvirt_domain.guest :
    vm.name => vm.network_interface.0.addresses.0
  }
}