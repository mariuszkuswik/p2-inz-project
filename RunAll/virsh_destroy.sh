# Virsh domains
virsh shutdown control-plane
virsh undefine control-plane
# Node1
virsh shutdown node1 
virsh undefine node1
# Node2
virsh shutdown node2
virsh undefine node2
# Volumes
virsh vol-delete control-plane.iso default
virsh vol-delete node1.iso default
virsh vol-delete node2.iso default
# Network
virsh net-undefine bridgenet 
virsh net-destroy bridgenet
