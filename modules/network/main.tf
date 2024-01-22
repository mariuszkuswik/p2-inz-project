module "constants" {
  source = "../constants"
}

resource "libvirt_network" "internal" {
  name = module.constants.network_common_name
  mode = "bridge"
  bridge = "virbrid"

  dhcp {
    enabled = true
  }
}
