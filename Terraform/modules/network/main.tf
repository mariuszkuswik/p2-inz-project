variable "network_name" {
  type = string
}

resource "libvirt_network" "internal" {
  name = var.network_name
  mode = "nat"

  addresses = ["192.168.2.0/24"]

  dhcp {
    enabled = true
  }
}
