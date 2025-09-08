# FastAPI on Minikube (Terraform Provisioned VM)

A complete infrastructure-as-code solution that demonstrates provisioning an Azure VM with Terraform, installing Docker + Minikube, and deploying a FastAPI application with Prometheus & Grafana monitoring. Includes CI/CD pipelines for automated build and deployment.

## 🎯 Project Overview

**What:** Reproducible infrastructure + application deployment: Azure VM (Terraform) → Minikube → FastAPI + monitoring

**Why:** Lightweight, single-VM Kubernetes playground for development, CI/CD demos, and observability experiments

## 📁 Repository Structure(high level overview)

```
├── fastapi_app/                # FastAPI application
│   ├── Dockerfile
│   ├── main.py
│   ├── requirements.txt
│   └── manifests/              # Kubernetes YAMLs (Deployment/Service/Ingress)
├── terraform/                  # Terraform code (root + modules)
│   ├── main.tf                 # Root module (calls compute/networking modules)
│   ├── modules/compute/main.tf # VM, NSG, outputs, null_resources
│   └── input.tfvars            # Terraform variables
├── .github/workflows/
│   ├── ci.yaml                 # CI pipeline (lint/test/build/push)
│   └── infra_and_deploy.yaml   # Infrastructure + CD workflow
└── docs/                       # Documentation and deployment guide
```

## 🔧 Prerequisites

### Local Environment
- `git`
- `docker`
- `kubectl`
- `minikube` (for local testing)

### VM/Runner Requirements
- Terraform
- Docker
- Minikube
- Helm
- kubectl

*Note: Setup scripts automatically install these on the provisioned VM*

### GitHub Setup
- DockerHub account and repository
- GitHub Secrets configured (see below)

## 🔑 Required GitHub Secrets

```
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN

ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID

VM_ADMIN_USERNAME
VM_ADMIN_PASSWORD
```

## 🏗️ Architecture Decisions

- **Terraform**: Reproducible Azure resource provisioning (VM, NIC, NSG, Public IP)
- **Remote-exec**: Automated VM setup with Minikube installation via null_resource
- **Minikube**: Local Kubernetes cluster for development and demos
- **Ingress (nginx)**: Single public endpoint for service exposure
- **CI/CD**: GitHub Actions for automated build, test, and deployment


## 🔄 CI/CD Pipeline

### Continuous Integration (`.github/workflows/ci.yaml`)
- **Lint**: Code quality checks with flake8
- **Test**: Unit tests with pytest
- **Build**: Docker image creation
- **Push**: Image deployment to DockerHub

### Continuous Deployment (`.github/workflows/infra_and_deploy.yaml`)
- **Provision Job**: Terraform infrastructure deployment
- **Deploy Job**: Repository sync to VM and Kubernetes manifest application


### Common Debug Commands
```bash
kubectl get pods -A
kubectl get svc -A
kubectl describe pod <pod> -n <namespace>
kubectl logs <pod> -n <namespace>
kubectl get endpoints fastapi-service -n default
```


## 📚 Detailed Deployment Guide

For step-by-step instructions with screenshots, see [`docs/DEPLOYMENT_GUIDE.md`](docs/DEPLOYMENT_GUIDE.md).


## 📈 Monitoring & Observability

This project includes a complete monitoring stack:
- **Prometheus**: Metrics collection and alerting
- **Grafana**: Visualization dashboards
