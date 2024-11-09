resource "libvirt_volume" "infra" {
  count = var.vm_infra_count

  name           = "${format("${var.vm_infra_name}%02s", count.index + 1)}.qcow2"
  pool           = libvirt_pool.pool.name
  base_volume_id = libvirt_volume.base.id
  size           = var.vm_size
}

data "template_file" "infra_user_data" {
  count = var.vm_infra_count

  template = file("${path.module}/cloud_init.yml")

  vars = {
    vm_hostname              = "${format("${var.vm_infra_name}%02s", count.index + 1)}.local"
    cloudinit_username       = var.cloudinit_username
    cloudinit_password       = var.cloudinit_password
    cloudinit_ssh_public_key = var.cloudinit_ssh_public_key
  }
}

data "template_file" "infra_network_config" {
  count = var.vm_infra_count

  template = file("${path.module}/network_config.yml")

  vars = {
    ip_address = cidrhost("192.168.2.128/25", count.index + var.vm_admin_count)
  }
}


resource "libvirt_cloudinit_disk" "infra" {
  count = var.vm_infra_count

  name           = "${format("${var.vm_infra_name}%02s", count.index + 1)}_cloudinit.iso"
  user_data      = data.template_file.infra_user_data[count.index].rendered
  network_config = data.template_file.infra_network_config[count.index].rendered
  pool           = libvirt_pool.pool.name
}

resource "libvirt_domain" "infra" {
  count = var.vm_infra_count

  name       = format("${var.vm_infra_name}%02s", count.index + 1)
  memory     = var.vm_memory
  vcpu       = var.vm_cpus
  running    = true
  autostart  = true
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.infra[count.index].id

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    bridge         = "br0"
    hostname       = format("${var.vm_infra_name}%02s", count.index + 1)
    addresses      = [cidrhost("192.168.2.128/25", count.index + var.vm_admin_count)]
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.infra[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_port = "3"
    target_type = "virtio"
  }
}
