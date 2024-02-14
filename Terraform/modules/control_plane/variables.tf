variable "hostname" { 
  type = string
  default = "control_plane"
}

variable "network_name" { 
  type = string
  default = "internal"
}

variable "control_plane_disk_path" {
  type    = string
}

variable "repo_path" {
  type    = string
  default = "/home/mariusz/p2-meta/repo/repos.iso"
}

variable "meta_path" {
  type    = string
  default = "/home/mariusz/p2-inz-project/Meta/meta.iso"
}

variable "ansible_path" {
  type    = string
  default = "/home/mariusz/p2-inz-project/Meta/ansible.iso"
}

variable "autostart" { 
  type = bool
  default = true
}