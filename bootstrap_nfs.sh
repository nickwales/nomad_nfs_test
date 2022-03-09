#!/usr/bin/env bash

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

apt update
apt install -y nfs-kernel-server avahi-daemon libnss-mdns

sudo mkdir /var/nfs/share -p
sudo mkdir /var/nfs/share_no_root -p
sudo chown nobody:nogroup /var/nfs/share*

sudo tee -a /etc/exports > /dev/null <<EOT
/var/nfs/share            192.168.1.0/24(rw,sync,no_subtree_check)
/var/nfs/share_no_root    192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)
EOT

echo "192.168.1.11 nomad" >> /etc/hosts

sudo systemctl restart nfs-kernel-server
