#!/usr/bin/env bash

echo "Deploy k3s resources..."
/usr/local/bin/kubectl apply -f /vagrant_shared/k3s/app-one.yaml
/usr/local/bin/kubectl apply -f /vagrant_shared/k3s/app-two.yaml
/usr/local/bin/kubectl apply -f /vagrant_shared/k3s/app-three.yaml

echo "Waiting for helm traefik jobs completion..."
/usr/local/bin/kubectl wait --for condition=complete --timeout=-1s job/helm-install-traefik-crd -n kube-system
/usr/local/bin/kubectl apply -f /vagrant_shared/k3s/ingress.yaml