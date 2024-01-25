module "network" {
  source            = "./modules/network"
  network_name      = "internal"
}

module "control_node" {
  source            = "./modules/control_plane"
  hostname          = "control_plane"
  network_name      = "internal"
}

module "node1" {
  source            = "./modules/node"
  hostname          = "node1" 
  node_disk_path    = "/home/mariusz/p2/terra_kvm/meta/rhel/rhel-8-node1.qcow2" 
}

module "node2" {
  source            = "./modules/node"
  hostname          = "node2" 
  node_disk_path    = "/home/mariusz/p2/terra_kvm/meta/rhel/rhel-8-node2.qcow2" 
}

# module "node2" {
#   source            = "./modules/node"
#   hostname          = "node2" 
# }