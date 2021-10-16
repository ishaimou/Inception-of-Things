#!/usr/bin/env bash

export INSTALL_K3S_CHANNEL="stable"
export INSTALL_K3S_EXEC="--flannel-iface=eth1"
export K3S_TOKEN_FILE=/vagrant_shared/token
export K3S_URL=https://#{server_ip}:6443

sudo -i
systemctl disable firewalld --now
curl -sfL https://get.k3s.io | sh -s -
echo "ks3 agent installed and configured successfully on ishaimouSW Worker Node"