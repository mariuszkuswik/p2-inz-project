module "network" {
  source            = "./modules/network"
}

module "control-plane" {
  source            = "./modules/control-plane"
}
