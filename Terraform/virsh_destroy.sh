#!/bin/bash

# Virsh domains
virsh shutdown control-plane
virsh undefine control-plane

virsh shutdown node1
virsh undefine node1

virsh shutdown node2
virsh undefine node2
# Volumes
virsh vol-delete control_plane.iso default
virsh vol-delete node1.iso default
virsh vol-delete node2.iso default
# Network
virsh net-undefine internal
virsh net-destroy internal

