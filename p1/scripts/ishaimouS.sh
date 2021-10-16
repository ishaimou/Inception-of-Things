#!/usr/bin/env bash

export INSTALL_K3S_CHANNEL="stable"
export INSTALL_K3S_EXEC="--bind-address=#{server_ip} --node-external-ip=#{server_ip} --flannel-iface=eth1"

sudo -i
systemctl disable firewalld --now
curl -sfL https://get.k3s.io | sh -s -
echo "Waiting for k3s to start"
sleep 5
cp /var/lib/rancher/k3s/server/token /vagrant_shared
cp /etc/rancher/k3s/k3s.yaml /vagrant_shared
echo "ks3 server installed and configured successfully on ishaimouS Server Node"