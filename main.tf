module "control_plane" {
  source            = "./control_plane"
  common_network_name = var.common_network_name
}

module "network" {
  source            = "./network"
  common_network_name = var.common_network_name
}
