#!/usr/bin/env bash

/usr/local/bin/kubectl apply -f /vagrant_shared/app-k3s-resources.yaml
/usr/local/bin/kubectl apply -f /vagrant_shared/ingress.yaml
/usr/local/bin/kubectl get all --all-namespaces