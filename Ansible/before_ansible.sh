#!/bin/bash 

sudo nmcli general hostname control-plane
sudo reboot now

ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix
