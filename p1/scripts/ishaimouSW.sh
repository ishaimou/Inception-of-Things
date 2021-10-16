#!/usr/bin/env bash

systemctl disable firewalld --now
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL="stable" \
K3S_URL="https://ishaimouS:6443" KS3_TOKEN=`cat ` sh -s -
echo ks3 agent installed successfully on ishaimouSW Worker Node