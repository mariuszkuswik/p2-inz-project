variable "node_disk_path" {
  type    = string
  default = "/home/mariusz/p2/terra_kvm/meta/rhel/rhel-8-control-plane.qcow2"
}

variable "repo_path" {
  type    = string
  default = "/home/mariusz/p2/terra_kvm/meta/repo/repos.iso"
}

variable "meta_path" {
  type    = string
  default = "/home/mariusz/p2-inz-project/Meta/meta.iso"
}

variable "ansible_path" {
  type    = string
  default = "/home/mariusz/p2-inz-project/Meta/ansible.iso"
}
