virt-install     --memory 4096     --vcpus 2     --name mytestcivm5     --disk /home/mariusz/p2/terra_kvm/meta/rhel/rhel-server-7.9-x86_64-kvm.qcow2,device=disk,bus=virtio,format=qcow2     --disk /home/mariusz/p2/terra_kvm/meta/cloud-init/ciiso.iso,device=cdrom     --os-type Linux  --os-variant rhel8.0    --virt-type kvm     --graphics none     --import
