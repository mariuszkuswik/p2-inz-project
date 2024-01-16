resource "libvirt_network" "internal" {
  name = var.common_network_name 
  mode = "nat"

  addresses = ["192.168.123.0/24"]
}
