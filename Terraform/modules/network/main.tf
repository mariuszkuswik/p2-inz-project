variable "network_name" {
  type = string
}

resource "libvirt_network" "bridgenet" {
  name   = var.network_name
  mode = "bridge"
  bridge = "nm-bridge2"

  dhcp {
    enabled = true
    # range = "192.168.1.151,192.168.1.200"
  }

  dns {
    enabled    = true
    local_only = false
    # servers = ["192.168.1.1","8.8.8.8","8.8.4.4"]
  }
}

