#!/usr/bin/env bash

systemctl disable firewalld --now
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL="stable" sh -s -
echo ks3 server installed successfully on ishaimouS Server Node