variable "network_name" {
  type = string
}

resource "libvirt_network" "internal" {
  name = var.network_name
  mode = "bridge"

  bridge {
    name           = "br0"
    interface_type = "ethernet"
  }


  addresses = ["192.168.1.0/24"]

  dhcp {
    enabled = true
  }
  
  dns { 
    enabled = true
    local_only = false
  }
}
   