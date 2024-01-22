module "network" {
  source            = "./modules/network"
}

module "control_node" {
  source            = "./modules/control_node"
  hostname          = "control_node"
}

# module "control-plane" {
#   source            = "./modules/control_plane"
# }

# module "node1" {
#   source            = "./modules/node"
#   hostname          = "node1" 
# }

# module "node2" {
#   source            = "./modules/node"
#   hostname          = "node2" 
# }
