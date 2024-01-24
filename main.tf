module "network" {
  source            = "./modules/network"
  network_name      = "internal"
}

module "control_node" {
  source            = "./modules/control_node"
  hostname          = "control_node"
  network_name      = "internal"
}

module "node1" {
  source            = "./modules/node"
  hostname          = "node1" 
}

# module "node2" {
#   source            = "./modules/node"
#   hostname          = "node2" 
# }
