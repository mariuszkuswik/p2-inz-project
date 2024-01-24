### MODULES ###
module "constants" {
   source = "../constants"
}

### VARIABLES ###
variable "hostname" { 
  type = string
}

variable "network_name" { 
  type = string
}

### CLOUD-INIT ###
data "template_file" "user_data" {
  template = file("${path.module}/user-data.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${var.hostname}.iso"
  user_data      = data.template_file.user_data.rendered
}

#################

### DISKS ###
resource "libvirt_volume" "node_cloud_image" {
  name   = var.hostname
  source = var.node_disk_path
  format = "qcow2"
}

### DOMAIN ###
resource "libvirt_domain" "node" {
  name   = var.hostname
  memory = 2024
  vcpu   = 1

  network_interface {
    network_name = var.network_name 
  }

  disk {
    volume_id = libvirt_volume.node_cloud_image.id
  }

  disk {
    volume_id = var.repo_path
  }

  graphics {
    type = "vnc"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

cloudinit = libvirt_cloudinit_disk.commoninit.id

}
