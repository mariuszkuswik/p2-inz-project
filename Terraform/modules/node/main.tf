###### NODE module ######
### CLOUD-INIT ###
## Template files declaration
data "template_file" "user_data" {
  template = file("${path.module}/user-data.cfg")
}
## cloud-init iso file
resource "libvirt_cloudinit_disk" "commoninit" {
  count       = var.num_instances
  name        = format("node%d.iso", count.index + 1)
  user_data      = data.template_file.user_data.rendered
}

### DISKS ###
resource "libvirt_volume" "node_disk_copy" {
  count       = var.num_instances
  name        = format("node%d.qcow2", count.index + 1)
  pool        = var.storage_pool
  source      = "/home/mariusz/p2-meta/rhel/rhel-8-node-sample.qcow2"
  format      = "qcow2"

}

### DOMAIN ###
resource "libvirt_domain" "node" {
  count = var.num_instances

  name   = format("node%d", count.index + 1)
  memory = 2024
  vcpu   = 1
  autostart = var.autostart

  network_interface {
    network_name  = var.network_name
    hostname      = format("node%d", count.index + 1)
    addresses     = [format("192.168.2.10%d", count.index + 1)]
  }

  disk {
    volume_id = libvirt_volume.node_disk_copy[count.index].id
  }

  graphics {
    type = "vnc"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

}
