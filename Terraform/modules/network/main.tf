variable "network_name" {
  type = string
}

<<<<<<< HEAD
<<<<<<< HEAD
variable "bridge_name" {
  type = string
  default = "br0"
}

=======
>>>>>>> parent of 31ba8d7 (bridge)
=======
>>>>>>> parent of 31ba8d7 (bridge)
resource "libvirt_network" "internal" {
  name = var.network_name
  mode = "nat"

  addresses = ["192.168.2.0/24"]

  dhcp {
    enabled = true
  }
  
  dns { 
    enabled = true
    local_only = false
  }
}
   