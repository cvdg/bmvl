
resource "libvirt_pool" "pool" {
  name = var.libvirt_pool_name
  type = "dir"

  target {
    path = var.libvirt_pool_path
  }
}

resource "libvirt_volume" "base" {
  name   = "${var.code}_base.img"
  pool   = libvirt_pool.pool.name
  source = var.base_img_url
  format = "qcow2"
}

resource "libvirt_volume" "root" {
  count          = var.vm_count
  name           = "${format("${var.vm_name}%02s-root", count.index + 1)}.qcow2"
  pool           = libvirt_pool.pool.name
  base_volume_id = libvirt_volume.base.id
  size           = 1024 * 1024 * 1024 * 32 # 32 GiB
}

resource "libvirt_volume" "data" {
  count  = var.vm_count
  name   = "${format("${var.vm_name}%02s-data", count.index + 1)}.qcow2"
  pool   = libvirt_pool.pool.name
  size   = 1024 * 1024 * 1024 * 128 # 128 GiB
  format = "qcow2"
}

data "template_file" "user_data" {
  count    = var.vm_count
  template = file("${path.module}/cloud_init.yml")

  vars = {
    vm_hostname              = "${format("${var.vm_name}%02s", count.index + 1)}.local"
    cloudinit_username       = var.cloudinit_username
    cloudinit_password       = var.cloudinit_password
    cloudinit_ssh_public_key = var.cloudinit_ssh_public_key
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  count     = var.vm_count
  name      = "${format("${var.vm_name}%02s", count.index + 1)}_cloudinit.iso"
  user_data = data.template_file.user_data[count.index].rendered #if you set network user no go
  pool      = libvirt_pool.pool.name
}

resource "libvirt_domain" "guest" {
  count      = var.vm_count
  name       = format("${var.vm_name}%02s", count.index + 1)
  memory     = var.vm_memory
  vcpu       = var.vm_cpus
  running    = true
  autostart  = true
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.cloudinit[count.index].id

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    bridge         = "br0"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.root[count.index].id
  }

  disk {
    volume_id = libvirt_volume.data[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}
