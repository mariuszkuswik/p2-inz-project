### MODULES ###
module "constants" {
   source = "../constants"
}

### CLOUD-INIT ###
data "template_file" "user_data" {
  template = file("${path.module}/user-data.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${var.hostname}.iso"
  user_data      = data.template_file.user_data.rendered
}

### DISKS ###
resource "libvirt_volume" "control_plane_image" {
  name   = var.hostname
  source = var.control_plane_disk_path
  format = "qcow2"
}

### DOMAIN ###
resource "libvirt_domain" "control_plane" {
  name   = var.hostname
  memory = 2024
  vcpu   = 2
  autostart = var.autostart

  network_interface {
    network_name = var.network_name 
  }

  disk {
    volume_id = libvirt_volume.control_plane_image.id
  }

  disk {
    file = var.repo_path
  }

  disk {
    file = var.meta_path
  }

  disk {
    file = var.ansible_path
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
