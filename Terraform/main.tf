module "network" {
  source            = "./modules/network"
  network_name      = "internal"
}

module "control_plane" {
  source            = "./modules/control_plane"
  hostname          = "control-plane"
  network_name      = "internal"
  autostart         = true
  control_plane_disk_path = "/home/mariusz/p2-meta/rhel/rhel-8-control-plane-sample.qcow2"
}

module "node" {
  # Number of instances!
  num_instances     = 1
  source            = "./modules/node"
  node_disk_path    = "/home/mariusz/p2-meta/rhel/rhel-8-node-sample.qcow2" 
  network_name      = "internal"
  autostart         = false
  storage_pool      = "default"
}
