module "network" {
  source            = "./modules/network"
  network_name      = "internal"
}

module "control_plane" {
  source            = "./modules/control_plane"
  hostname          = "control_plane"
  network_name      = "internal"
  autostart         = true
  control_plane_disk_path = "/home/mariusz/p2-meta/rhel/rhel-8-control-plane-sample.qcow2"
}

module "node" {
  # Number of instances!
  num_instances     = 2
  source            = "./modules/node"
  # hostname          = "node1" 
  node_disk_path    = "/home/mariusz/p2-meta/rhel/rhel-8-node-sample.qcow2" 
  network_name      = "internal"
  # addresses         = "[192.168.2.101]"
  autostart         = false
  storage_pool      = "default"
}


# module "node2" {
#   source            = "./modules/node"
#   hostname          = "node2" 
#   node_disk_path    = "/home/mariusz/p2-meta/rhel/rhel-8-node2.qcow2" 
# }

