variable "autostart" { 
  type = bool
  default = false
}

variable "network_name" { 
  type = string
  default = "bridgenet"
}

variable "node_disk_path" {
  type    = string
}

# Number of the node instances
variable "num_instances" {
  type    = number
  default = 1  
}

variable "storage_pool" {
  type    = string
  default = "default"
}
