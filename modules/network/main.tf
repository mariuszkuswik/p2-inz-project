module "constants" {
   source = "../constants"
}

resource "libvirt_network" "internal" {
  # name = "internal"
  name = module.constants.network_common_name
  mode = "nat"

  addresses = ["192.168.123.0/24"]

  dhcp {
    enabled = true 
  }

}
