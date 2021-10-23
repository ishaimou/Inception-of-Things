#!/usr/bin/env bash

export INSTALL_K3S_CHANNEL="stable"
export INSTALL_K3S_EXEC="--flannel-iface=eth1"
export K3S_TOKEN_FILE="/vagrant_shared/node-token"
export K3S_URL="https://$1:6443"

curl -sfL https://get.k3s.io | sh -s -
echo 'alias k="k3s kubectl"' >> /home/vagrant/.bashrc
sudo yum install net-tools -y
echo "ks3 agent installed and configured successfully on ishaimouSW Worker Node"