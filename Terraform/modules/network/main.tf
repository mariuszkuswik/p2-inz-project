variable "network_name" {
  type = string
}

resource "libvirt_network" "bridgenet" {
  name   = var.network_name
  mode = "bridge"
  bridge = "nm-bridge2"

  dhcp {
    enabled = false 
  }

  dns {
    enabled    = true
    local_only = false
    hosts {
      hostname = "google"
      ip = "8.8.8.8"
    }
  }
}

