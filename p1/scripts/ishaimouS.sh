#!/usr/bin/env bash

export INSTALL_K3S_CHANNEL="stable"
export INSTALL_K3S_EXEC="--bind-address=$1 --flannel-iface=eth1 --write-kubeconfig-mode=644"

curl -sfL https://get.k3s.io | sh -s -
cp /var/lib/rancher/k3s/server/node-token /vagrant_shared
echo 'alias k="k3s kubectl"' >> /home/vagrant/.bashrc
sudo yum install net-tools -y
echo "ks3 server installed and configured successfully on ishaimouS Server"