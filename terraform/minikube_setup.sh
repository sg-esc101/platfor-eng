#!/bin/bash
set -e

echo "=== Starting Minikube ==="
sudo minikube start --driver=docker --cpus=2 --memory=4096

echo "=== Enabling NGINX ingress addon ==="
sudo minikube addons enable ingress

echo "=== Installing Prometheus & Grafana via Helm ==="
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace

# Install Grafana
helm install grafana grafana/grafana --namespace monitoring

echo "=== Kubernetes cluster is ready with monitoring & ingress ==="
