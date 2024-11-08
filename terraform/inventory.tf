resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.yml",
    {
      vms = libvirt_domain.guest.*
    }
  )
  filename = "../ansible/inventory.yml"
}
