resource "libvirt_volume" "control_plane_system_drive" {
  name = "example-vm-disk"
  size = 10
}

resource "libvirt_volume" "control_plane_cloud_image" {
  name   = var.control_plane_name
  source = var.control_plane_disk_path
  format = "qcow2"
}


resource "libvirt_domain" "control_plane" {
  name   = var.control_plane_name
  memory = 2024
  vcpu   = 1

  network_interface {
    network_name = libvirt_network.internal.name
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

cloudinit {
    user_data = var.control_plane_cloud_init
  }

}