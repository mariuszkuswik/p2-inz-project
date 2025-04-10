#!/bin/bash

sudo rm /var/lib/libvirt/images/virsh-pool-default/meta.iso /var/lib/libvirt/images/virsh-pool-default/ansible.iso

# Meta files iso
sudo genisoimage -o "/var/lib/libvirt/images/virsh-pool-default/meta.iso" -J -r "../Meta/" 
# Ansible scripts iso
sudo genisoimage -o "/var/lib/libvirt/images/virsh-pool-default/ansible.iso" -J -r "../Ansible/" 

sudo chown 107:107 /var/lib/libvirt/images/virsh-pool-default/meta.iso
sudo chown 107:107 /var/lib/libvirt/images/virsh-pool-default/ansible.iso

cd ../Terraform 
terraform init 
terraform apply -lock=false

cd ../RunAll
./run_ansible.sh 
