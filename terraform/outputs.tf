output "admin_ip_address" {
  value = {
    for vm in libvirt_domain.admin :
    vm.name => vm.network_interface.0.addresses.0
  }
}

output "infra_ip_address" {
  value = {
    for vm in libvirt_domain.infra :
    vm.name => vm.network_interface.0.addresses.0
  }
}
