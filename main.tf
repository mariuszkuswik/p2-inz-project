module "control_plane" {
  source            = "./modules/control-plane"
  common_network_name = var.common_network_name
}

resource "libvirt_network" "internal" {
  name = var.common_network_name 
  mode = "nat"

  addresses = ["192.168.123.0/24"]
}
