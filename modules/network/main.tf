resource "libvirt_network" "internal" {
 name = "internal"
 mode = "nat"

 addresses = ["192.168.123.0/24"]  # Adjust the IP address based on your network configuration

}