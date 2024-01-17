module "control-plane" {
  source            = "./modules/control-plane"
}

module "network" {
  source            = "./modules/network"
}
