resource "libvirt_volume" "example_vm_disk" {
  name = "example-vm-disk"
  size = 10
}

resource "libvirt_volume" "cloud_image" {
  name   = "rocky1"
  source = "/home/mariusz/p2/terra_kvm/meta/rhel/rhel-server-7.9-x86_64-kvm.qcow2"
  format = "qcow2"
}

