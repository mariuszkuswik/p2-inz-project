module "network" {
  source            = "./modules/network"
}

module "control-plane" {
  source            = "./modules/control-plane"
}

module "node1" {
  source            = "./modules/node"
  hostname          = "node1" 
}
