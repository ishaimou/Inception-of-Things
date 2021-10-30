#!/usr/bin/env bash

# --- Environnement Setup --- #

# Disable firewall
sudo systemctl disable firewalld --now

# Install Docker Engine on Centos8
# Set up Docker repository
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# Installing the Latest Docker
sudo yum install docker-ce docker-ce-cli containerd.io --allowerasing -y
# Start Docker as a service
sudo systemctl start docker

# Post-installation Configuration
# Configure Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Test Docker Installation
docker run hello-world

# Install kubectl binary
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
echo "source <(kubectl completion bash)" >>~/.bashrc
echo "alias k='kubectl'" >>~/.bashrc
echo "complete -F __start_kubectl k" >>~/.bashrc
source ~/.bashrc

# Install k3d Current Latest Release
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# --- Cluster Setup --- #

# Create k3d Cluster
k3d cluster create --config ../confs/k3d-config.yaml
# k3d cluster create p3-cluster -p 8080:80@loadbalancer -p 8443:443@loadbalancer -p 8888:8888@loadbalancer

# Retrieve Cluster Info
kubectl cluster-info

# Create Namespaces
kubectl create namespace argocd
kubectl create namespace dev

# Install ArgoCD
# https://github.com/argoproj/argo-cd/raw/stable/manifests/install.yaml
# to disable TLS edit the argocd-server deployment to add the --insecure flag to the argocd-server command
kubectl apply -f ../confs/install.yaml -n argocd
# Wait for argocd-server to be ready
kubectl rollout status deploy argocd-server -n argocd
# kubectl port-forward svc/argocd-server -n argocd 8080:443
# Create Ingress to access ArgoCD UI
kubectl apply -f ../confs/ingress.yaml -n argocd

# Get default password for the admin user
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Set ArgoCD Admin Password to <admin>
kubectl -n argocd patch secret argocd-secret \
    -p '{"stringData": {
    "admin.password": "$2a$12$TOdvA6Ud4D.FY8tP3OWDdOWGAeJ4xZ6YUPSjAjKydhrqhZieUEIaS",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

# Install argocd App
kubectl apply -f ../confs/argocd-app.yaml -n argocd

# kubectl get applications -n argocd
