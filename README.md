# 🚀 DevOps Cloud Project — Dual-Cloud Kubernetes, Blue-Green & DevSecOps

[![GitHub repo](https://img.shields.io/badge/GitHub-devops--cloud--project-blue?logo=github)](https://github.com/Aisha-gif2003/devops-cloud-project)
[![DevSecOps](https://img.shields.io/badge/DevSecOps-Gitleaks%20%7C%20Trivy%20%7C%20npm%20audit-green?logo=githubactions)](.github/workflows/security.yml)

A Node.js (Express) application deployed to **both Azure and AWS** with Infrastructure as Code, automated CI/CD, **blue-green zero-downtime deployments**, **security scanning in the pipeline (DevSecOps)**, and real monitoring — built end to end as a hands-on DevOps portfolio project.

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
├── blue-green/                # Blue-green deployments + traffic switch scripts
├── monitoring/                # Grafana/Prometheus manifests
├── scripts/                   # Local Minikube deploy scripts (deploy.sh / deploy.ps1)
├── infra/
│   ├── main.bicep             # Azure: ACR + AKS + AcrPull role assignment
│   ├── deploy-aks.sh          # One-shot Azure provision + deploy script
│   └── aws/main.tf            # AWS: ECR + ECS Fargate + ALB + IAM + CloudWatch
└── .github/workflows/
    ├── ci-cd.yml              # Build → push → deploy pipeline (manual trigger)
    └── security.yml           # DevSecOps scans: Gitleaks, npm audit, Trivy
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

## 🔵🟢 Blue-Green Deployment (zero downtime + instant rollback)

Two identical environments run side by side; a Kubernetes Service selector decides which one receives **all** traffic. Releasing = flipping the selector. Rollback = flipping it back. No pods are restarted, no requests are dropped.

```
                     ┌──────────────────────┐
   users ──────────► │ Service (selector:   │
                     │   version: blue ◄─┐  │   flip with switch.ps1 / switch.sh
                     └───────┬───────────┼──┘
                             ▼           ▼
                   ┌───────────────┐  ┌───────────────┐
                   │ Deployment    │  │ Deployment    │
                   │ BLUE  (v1)    │  │ GREEN (v2)    │
                   │ 2 pods        │  │ 2 pods        │
                   └───────────────┘  └───────────────┘
```

Try it locally (free — Minikube + Docker Desktop):

```powershell
.\blue-green\demo-setup.ps1            # build image, deploy blue + green + service
minikube service nodejs-bg-service --url   # open the app (BLUE page)
.\blue-green\switch.ps1 green          # flip traffic → refresh browser → GREEN page
.\blue-green\switch.ps1 blue           # instant rollback
```

## 🔐 DevSecOps Pipeline

Security is checked automatically on every push and pull request ([security.yml](.github/workflows/security.yml)):

| Check | Tool | Catches |
|-------|------|---------|
| **Secret scanning** | Gitleaks | Committed passwords, API keys, tokens (full git history) |
| **Dependency audit** | npm audit | Known CVEs in npm packages (fails on high/critical) |
| **Container image scan** | Trivy | OS & app-layer vulnerabilities in the built Docker image |
| **IaC scan** | Trivy config | Misconfigurations in Terraform, K8s manifests, Dockerfile |

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
