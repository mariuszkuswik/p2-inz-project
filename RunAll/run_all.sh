#!/bin/bash

rm Meta/meta.iso Meta/ansible.iso

# Meta files iso
genisoimage -o "../Meta/meta.iso" -J -r "../Meta/" 
# Ansible scripts iso
genisoimage -o "../Meta/ansible.iso" -J -r "../Ansible/" 

cd ../Terraform 
terraform init 
terraform apply
