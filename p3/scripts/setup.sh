echo "Install Docker Engine on Ubuntu"
# Updating the Software Repository
sudo apt-get update
# Downloading Dependencies
sudo apt-get install ca-certificates curl gnupg lsb-release
# Adding Docker’s GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#  Installing the Docker Repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Installing the Latest Docker
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "Install k3d Current Latest Release"
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

echo "Create k3d Cluster"
k3d cluster create --config ../confs/k3d-config.yaml
# k3d cluster create ishaimou-cluster -p 8080:80@loadbalancer -p 8443:443@loadbalancer -p 8888:8888@loadbalancer

echo "Create Namespaces"
kubectl create namespace argocd
kubectl create namespace dev

echo "Install ArgoCD"
kubectl apply -f https://github.com/argoproj/argo-cd/raw/v1.6.2/manifests/install.yaml -n argocd

echo "Set ArgoCD Admin Password"
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "YWRtaW4=",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

kubectl apply -f ../confs/argocd-app.yaml -n argocd

echo "Install dev App"
kubectl apply -f ../confs/deployment.yaml -n env
kubectl apply -f ../confs/service.yaml -n env
