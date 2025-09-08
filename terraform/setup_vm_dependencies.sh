#!/bin/bash
set -e  # Exit on any error

# --- Prevent interactive prompts during apt installs/upgrades ---
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
sudo sh -c 'echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections'
sudo sh -c 'echo "needrestart needrestart/restart select a" | debconf-set-selections'

echo "=== Updating system packages ==="
sudo apt-get update -y
sudo apt-get -o Dpkg::Options::="--force-confdef" \
             -o Dpkg::Options::="--force-confold" \
             -y upgrade

echo "=== Installing prerequisites ==="
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release git software-properties-common


# --- Docker ---
echo "=== Installing Docker ==="
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg || true; done

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- kubectl ---
echo "=== Installing kubectl ==="
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# --- Minikube ---
echo "=== Installing Minikube ==="
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# --- Helm ---
echo "=== Installing Helm ==="
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -s -- --version v3.15.4

echo "=== Tool installation complete ==="



