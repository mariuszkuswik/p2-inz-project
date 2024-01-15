name="mytestcivm5"
memory="4096"
vcpus="2"
main_disk="/home/mariusz/p2/terra_kvm/meta/rhel/rhel-server-7.9-x86_64-kvm.qcow2,device=disk,bus=virtio,format=qcow2"
ci_disk="/home/mariusz/p2/terra_kvm/meta/cloud-init/ciiso.iso,device=cdrom"
virt-install --memory "$memory" --vcpus 2 --name mytestcivm5 --disk "$main_disk" --disk "$ci_disk" --os-type Linux  --os-variant rhel8.0 --virt-type kvm  --graphics none  --import
