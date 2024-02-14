variable "hostname" { 
  type = string
}

variable "autostart" { 
  type = bool
  default = false
}

variable "network_name" { 
  type = string
  default = "internal"
}

variable "addresses" { 
  type = string
}

variable "node_disk_path" {
  type    = string
}

