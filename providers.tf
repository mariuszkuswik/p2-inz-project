terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      # Specify the version if needed
      # version = "x.y.z"
    }
  }
}

provider "libvirt" {
  # Configuration for the libvirt provider
}

