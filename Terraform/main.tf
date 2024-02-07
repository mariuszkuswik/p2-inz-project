module "network" {
  source            = "./modules/network"
  network_name      = "internal"
}

module "control_node" {
  source            = "./modules/control_plane"
  hostname          = "control_plane"
  network_name      = "internal"
}

