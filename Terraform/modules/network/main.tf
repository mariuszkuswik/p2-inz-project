variable "network_name" {
  type = string
}

variable "bridge_name" {
  type = string
  default = "br0"
}

resource "libvirt_network" "internal" {
  name = var.network_name
  mode = "bridge"

  bridge = var.bridge_name

#   addresses = ["192.168.2.0/24"]

  # dhcp {
    # enabled = true
  # }
  
  # dns { 
    # enabled = true
    # local_only = false
  # }
}
   