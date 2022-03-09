#!/usr/bin/env bash

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y nomad nfs-common avahi-daemon libnss-mdns docker-ce docker-ce-cli containerd.io

sudo mkdir /nfs/share -p
sudo mkdir /nfs/share_no_root -p
sudo chown nobody:nogroup /nfs/share*

sudo tee -a /etc/fstab > /dev/null <<EOT
nfs.local:/var/nfs/share          /nfs/share nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
nfs.local:/var/nfs/share_no_root  /nfs/share_no_root nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
EOT

sudo tee /etc/nomad.d/nomad.hcl > /dev/null <<EOT
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

server {
  # license_path is required as of Nomad v1.1.1+
  #license_path = "/etc/nomad.d/nomad.hcl"
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  servers = ["127.0.0.1"]

  host_volume "nfs" {
    path = "/nfs/share"
    read_only = false
  }

  host_volume "nfs_no_root" {
    path = "/nfs/share_no_root"
    read_only = false
  }

}
EOT

echo "192.168.1.10 nfs" >> /etc/hosts

mount -a

systemctl enable --now docker
systemctl enable --now nomad

