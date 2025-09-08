# Deployment Guide

This guide explains how to deploy the project using the provided GitHub Actions workflows.

---

## 1. CI Workflow (ci.yaml)

### Trigger
* Runs automatically on push to the **main** branch.
* Can be run manually using `workflow_dispatch` from the GitHub Actions tab.

### Purpose
* Lints and validates Terraform code.
* Runs unit tests.
* Builds and validates the application container image.
* Ensures the repository is in a good state before deployment.

### Steps
1. Navigate to your repository's **Actions** tab.
2. Select the **CI** workflow.
3. Trigger it manually, if needed, using **Run workflow**.
   <img width="1898" height="444" alt="image" src="https://github.com/user-attachments/assets/c9c287ec-819f-419f-9f4a-b1b5b1b3a429" />


---

## 2. Infrastructure & Deployment Workflow (infra_and_deploy.yaml)

### Trigger
* Only run after the **CI** workflow has completed successfully.
* Must be triggered manually using `workflow_dispatch`.

### Purpose
* Provisions infrastructure using Terraform, including a VM and networking.
* Deploys the FastAPI application, Prometheus, Grafana, and Ingress.

### Steps
1. Go to your repository's **Actions** tab.
2. Select the **Infra and Deploy** workflow.
3. Trigger it manually using **Run workflow**.
4. Monitor the logs to see the VM provisioning and deployment progress.

---

## 3. Accessing the Application

After deployment, the VM's public IP will be available in the workflow output as `vm_ip`. Use this IP to access the following services:

* **FastAPI**: `http://<vm_ip>/`
* **Grafana**: `http://<vm_ip>/grafana`
* **Prometheus**: `http://<vm_ip>/prometheus`

---

## 4. Notes

* Ensure that Network Security Group (NSG) or firewall rules allow HTTP/HTTPS access to the VM.
* If you have trouble accessing services, you can check the Kubernetes services and ingress setup on the VM using the following commands:
    * `kubectl get svc -A`
    * `kubectl get ingress -A`
