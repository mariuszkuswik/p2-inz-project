#!/bin/bash

sudo rm /var/lib/libvirt/images/virsh-pool-default/mounts.iso

# Mounts files iso
sudo genisoimage -o "/var/lib/libvirt/images/virsh-pool-default/mounts.iso" -J -r "../Mounts/" 

sudo chown 107:107 /var/lib/libvirt/images/virsh-pool-default/mounts.iso

cd ../Terraform 
terraform init 
terraform apply -lock=false

cd ../RunAll
./run_ansible.sh 
