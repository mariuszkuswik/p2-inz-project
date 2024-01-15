module "network" {
  source = "./modules/network"
}

module "control-plane" {
  source = "./modules/network"
}

# module "instance" {
  # source = "./modules/network"
# }