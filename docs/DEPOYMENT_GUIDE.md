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


<img width="1920" height="633" alt="image" src="https://github.com/user-attachments/assets/19aaee45-10fd-432f-8e30-e01f8def7801" />

<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/6e01690e-667e-456a-8f2a-fe7f354142b6" />

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

<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/b9798210-be51-4713-915d-5c32b8555e50" />

<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/1125f3f9-4766-43d2-8051-ff95f80f22c0" />

<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/124bb095-94c9-4673-8fa5-cb06fc786e08" />

---

## 3. Accessing the Application

After deployment, the VM's public IP will be available in the workflow output as `vm_ip`. Use this IP to access the following services:

* **FastAPI**: `http://<vm_ip>/`
* **Grafana**: `http://<vm_ip>/grafana`
* **Prometheus**: `http://<vm_ip>/prometheus`
<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/f2265dd6-1b9c-467f-bb8c-a54684628550" />

<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/2d1907f5-170e-4dca-bdff-99dd3ffa1154" />


<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/f209383e-7a98-4ffe-a4a0-c7fa9c339610" />

<img width="1920" height="780" alt="image" src="https://github.com/user-attachments/assets/a9610c09-d901-46a6-843c-60b06e481089" />

---

## 4. Notes

* Ensure that Network Security Group (NSG) or firewall rules allow HTTP/HTTPS access to the VM.
* If you have trouble accessing services, you can check the Kubernetes services and ingress setup on the VM using the following commands:
    * `kubectl get svc -A`
    * `kubectl get ingress -A`


