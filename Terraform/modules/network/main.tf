resource "libvirt_network" "internal" {
  name = var.network_name
  mode = "bridge"

  bridge {
    name           = "br0"
    interface_type = "ethernet"
  }

  addresses = ["192.168.0.0/24"]  # Adjust the subnet to match your network

  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = false
  }
}
