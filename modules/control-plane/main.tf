### MODULES ###
module "constants" {
   source = "../constants"
}


### CLOUD-INIT ###
data "template_file" "user_data" {
  template = file("${path.module}/user-data.cfg")
}

data "template_file" "meta_data" {
  template = file("${path.module}/meta-data.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  meta_data      = data.template_file.meta_data.rendered
  
}

#################

### DISKS ###
resource "libvirt_volume" "control_plane_system_drive" {
  name = "example-vm-disk"
  size = 10
}

resource "libvirt_volume" "control_plane_cloud_image" {
  name   = var.control_plane_name
  source = var.control_plane_disk_path
  format = "qcow2"
}

### DOMAIN ###
resource "libvirt_domain" "control_plane" {
  name   = var.control_plane_name
  memory = 2024
  vcpu   = 1

  network_interface {
    network_name = module.constants.network_common_name
  }

  disk {
    volume_id = libvirt_volume.control_plane_cloud_image.id
  }

  disk {
    volume_id = libvirt_volume.control_plane_system_drive.id
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
