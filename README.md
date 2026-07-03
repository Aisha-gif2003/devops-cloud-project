# 🚀 DevOps Cloud Project — Dual-Cloud Kubernetes & Containers

[![GitHub repo](https://img.shields.io/badge/GitHub-devops--cloud--project-blue?logo=github)](https://github.com/Aisha-gif2003/devops-cloud-project)

A Node.js (Express) application deployed to **both Azure and AWS** with Infrastructure as Code, automated CI/CD, and real monitoring — built end to end as a hands-on DevOps portfolio project.

---

## 🏗️ Architecture

```
                        GitHub Actions (push to main)
                                   │
                 ┌─────────────────┴─────────────────┐
                 ▼                                   ▼
        ┌──── AZURE ────┐                   ┌──── AWS ─────┐
        │ docker build  │                   │ docker build │
        │      ↓        │                   │      ↓       │
        │ ACR (registry)│                   │ ECR (registry)│
        │      ↓        │                   │      ↓       │
        │ AKS cluster   │                   │ ECS Fargate  │
        │ (Kubernetes)  │                   │ + ALB        │
        │      ↓        │                   └──────────────┘
        │ LoadBalancer  │
        │ + Prometheus/ │
        │   Grafana     │
        └───────────────┘
```

## ☁️ What's Inside

| Area | Azure | AWS |
|------|-------|-----|
| **IaC** | Bicep ([infra/main.bicep](infra/main.bicep)) | Terraform ([infra/aws/main.tf](infra/aws/main.tf)) |
| **Registry** | Azure Container Registry | Amazon ECR |
| **Compute** | AKS (Kubernetes, Standard_B2s_v2) | ECS Fargate (serverless containers) |
| **Networking** | LoadBalancer Service + Ingress | Application Load Balancer |
| **Monitoring** | Prometheus + Grafana (kube-prometheus-stack via Helm) | CloudWatch Logs |
| **CI/CD** | GitHub Actions → ACR → AKS | GitHub Actions → ECR → ECS |

## 📁 Project Structure

```
├── server.js                  # Express.js application
├── Dockerfile                 # Container image definition
├── node-app.yaml              # K8s Deployment + Service (image templated at deploy time)
├── my-ingress.yaml            # K8s Ingress
├── persistent-volume.yaml     # K8s storage config
├── monitoring/                # Grafana/Prometheus manifests
├── scripts/                   # Local Minikube deploy scripts (deploy.sh / deploy.ps1)
├── infra/
│   ├── main.bicep             # Azure: ACR + AKS + AcrPull role assignment
│   ├── deploy-aks.sh          # One-shot Azure provision + deploy script
│   └── aws/main.tf            # AWS: ECR + ECS Fargate + ALB + IAM + CloudWatch
└── .github/workflows/ci-cd.yml  # Build → push → deploy pipeline
```

## ⚙️ CI/CD Pipeline

On every push to `main`, GitHub Actions:
1. Builds the Docker image
2. Pushes it to the cloud registry (tagged with the commit SHA)
3. Deploys to the cluster — with a safety check that **skips AKS deploy when the cluster is stopped** (cost control on student credit)

Required repo secrets: `AZURE_CREDENTIALS`, `AZURE_RESOURCE_GROUP`, `ACR_NAME`, `AKS_CLUSTER_NAME` (and `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` for the AWS job).

## 🚀 Deploy It Yourself

### Azure (AKS + ACR via Bicep)
```bash
az group create --name devops-cloud-rg --location centralindia
./infra/deploy-aks.sh devops-cloud-rg v1
```

### AWS (ECS Fargate + ECR via Terraform)
```bash
cd infra/aws
terraform init && terraform apply
# outputs the ECR repo URL and the public ALB app URL
```

### Local (Minikube)
```powershell
.\scripts\deploy.ps1
```

## 📊 Monitoring

Prometheus + Grafana deployed on AKS via the `kube-prometheus-stack` Helm chart — live node/pod metrics, pre-built cluster dashboards, and Alertmanager.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

## 💰 Cost Management

Built on **Azure for Students** + AWS free-tier-conscious choices:
- AKS: free control plane, single B-series node, `az aks stop` when idle
- AWS: Fargate (no cluster fee, per-second billing), everything torn down with `terraform destroy` after demos

---

*Cloud resources are provisioned on demand and deleted after demos — the IaC in this repo recreates the full environment in minutes.*
