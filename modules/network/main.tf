resource "libvirt_network" "internal" {
  name = "internal"
  mode = "nat"

  addresses = ["192.168.123.0/24"]
}

output "internal_network_name" {
  value = libvirt_network.internal.name
}

