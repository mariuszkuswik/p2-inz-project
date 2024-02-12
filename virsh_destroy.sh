# Virsh domains
virsh shutdown control_plane
virsh undefine control_plane
# Volumes
virsh vol-delete control_plane.iso default
virsh vol-delete node1.iso default
virsh vol-delete node2.iso default
# Network
virsh net-undefine internal
virsh net-destroy internal
