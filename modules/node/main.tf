### MODULES ###
module "constants" {
   source = "../constants"
}

### VARIABLES ###
variable "hostname" { 
  type = string
}


### CLOUD-INIT ###
data "template_file" "user_data" {
  template = file("${path.module}/user-data.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
}

#################

### DISKS ###
resource "libvirt_volume" "node_system_drive" {
  name = "example-vm-disk"
  size = 10
}

resource "libvirt_volume" "node_cloud_image" {
  name   = var.node_name
  source = var.node_disk_path
  format = "qcow2"
}

### DOMAIN ###
resource "libvirt_domain" "node" {
  name   = var.hostname
  memory = 2024
  vcpu   = 1

  network_interface {
    network_name = module.constants.network_common_name
  }

  disk {
    volume_id = libvirt_volume.node_cloud_image.id
  }

  disk {
    volume_id = libvirt_volume.node_system_drive.id
  }

  graphics {
    type = "vnc"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

cloudinit = libvirt_node_disk.commoninit.id

}
