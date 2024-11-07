resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
     vms = libvirt_domain.guest.*
    }
  )
  filename = "../ansible/inventory.yml"
}
