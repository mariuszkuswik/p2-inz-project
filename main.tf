resource "libvirt_network" "internal" {
 name = "internal"
 mode = "nat"

 addresses = ["192.168.123.0/24"]  # Adjust the IP address based on your network configuration

}

resource "libvirt_volume" "example_vm_disk" {
  name = "example-vm-disk"
  size = 10
}

resource "libvirt_volume" "cloud_image" {
  name   = "rocky1"
  source = "/home/mariusz/p2/terra_kvm/meta/rhel/rhel-server-7.9-x86_64-kvm.qcow2"
  format = "qcow2"
}


resource "libvirt_domain" "example_vm" {
  name   = "rhel1"
  memory = 2024
  vcpu   = 1

  network_interface {
    network_name = libvirt_network.internal.name
  }

  disk {
    volume_id = libvirt_volume.cloud_image.id
  }

  disk {
    volume_id = libvirt_volume.example_vm_disk.id
  }

  graphics {
    type = "vnc"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

cloudinit {
    user_data = <<-EOF
#cloud-config

users:
  - name: root
    ssh-authorized-keys:
      - ssh-rsa YOUR_SSH_PUBLIC_KEY

chpasswd:
  list: |
    root:NEW_ROOT_PASSWORD
  expire: False
EOF
  }

}
