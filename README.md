# 🚀 Complete DevOps Cloud-Native Project for Resume

**A production-like full-stack DevOps project demonstrating modern cloud-native architecture, CI/CD automation, and observability.**

---

## 📋 Project Overview

This project showcases a **complete end-to-end DevOps workflow** — from containerization to Kubernetes orchestration, CI/CD automation, and monitoring. It simulates real-world deployment practices used by cloud infrastructure teams.

**Tech Stack:**
- **Application:** Node.js REST API
- **Containerization:** Docker
- **Orchestration:** Kubernetes (Minikube locally, AKS concepts for Azure)
- **CI/CD:** GitHub Actions
- **Monitoring:** Prometheus + Grafana
- **Deployment Strategy:** Blue-Green Deployment (zero-downtime)

---

## 🎯 What This Project Demonstrates

✅ **Full DevOps Workflow**
- REST API development in Node.js
- Docker containerization with best practices
- Kubernetes manifests for deployment (local & cloud)
- Multi-environment setup (dev/prod namespaces)

✅ **Automated CI/CD Pipeline**
- GitHub Actions workflow for automated builds and testing
- Docker image builds and pushes to registry
- Automatic deployment to Kubernetes on every commit
- Environment-specific deployments

✅ **Production-Grade Features**
- Blue-green deployment strategy for safe releases
- Health checks and readiness/liveness probes
- Resource requests and limits
- Security best practices (RBAC concepts, secrets management)

✅ **Observability & Monitoring**
- Prometheus for metrics collection
- Grafana dashboards for visualization
- Application and infrastructure-level monitoring

---

## 🛠️ How to Run Locally

### Prerequisites
- Docker Desktop (with Kubernetes enabled)
- kubectl configured
- Node.js 14+

### Setup Instructions

1. **Clone and navigate:**
   ```bash
   git clone https://github.com/Aisha-gif2003/devops-cloud-project.git
   cd devops-cloud-project
   ```

2. **Build Docker image:**
   ```bash
   docker build -t devops-api:latest .
   ```

3. **Deploy to Kubernetes:**
   ```bash
   kubectl apply -f k8s/
   kubectl get pods
   ```

4. **Access application:**
   ```bash
   kubectl port-forward svc/devops-api-service 3000:3000
   # Visit: http://localhost:3000
   ```

5. **Setup Monitoring:**
   ```bash
   kubectl apply -f monitoring/
   kubectl port-forward svc/grafana 3001:80
   # Visit: http://localhost:3001 (admin/admin)
   ```

---

## 🔄 CI/CD Pipeline

**GitHub Actions Workflow:**
1. Trigger: Push to `main` branch
2. Build: Compile app, run tests
3. Containerize: Build Docker image, push to registry
4. Deploy: Update Kubernetes with new image
5. Verify: Health checks validate deployment

**Deployment Strategy: Blue-Green**
- Maintain two production environments
- Deploy to inactive environment first
- Switch traffic after successful health checks
- Instant rollback capability

---

## 📂 Project Structure

```
devops-cloud-project/
├── app/
│   ├── server.js          # Node.js REST API
│   ├── package.json       # Dependencies
│   └── health-check.js    # Liveness/readiness probes
├── docker/
│   └── Dockerfile         # Multi-stage build
├── k8s/
│   ├── deployment.yaml    # Kubernetes deployment
│   ├── service.yaml       # Kubernetes service
│   ├── configmap.yaml     # Configuration
│   └── secrets.yaml       # Secrets management
├── .github/workflows/
│   └── ci-cd.yml          # GitHub Actions pipeline
├── monitoring/
│   ├── prometheus.yaml    # Prometheus config
│   └── grafana-dashboard.json
└── README.md
```

---

## 🔐 Security Features

- Docker image vulnerability scanning
- Kubernetes RBAC concepts
- Secrets management with kubectl
- Network policies for pod communication
- Resource limits to prevent DoS
- Non-root container user

---

## 📊 Monitoring & Observability

**Prometheus Metrics:**
- `api_requests_total` — Total API requests
- `api_duration_seconds` — Request latency
- `docker_container_cpu_usage` — CPU usage
- `docker_container_memory_usage` — Memory usage

**Grafana Dashboards:**
- Application performance metrics
- Infrastructure metrics (CPU, memory, disk)
- Deployment status and rollout progress

---

## 🚀 Cloud Deployment (Azure AKS)

```bash
# Create AKS cluster
az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 2

# Push image to Azure Container Registry
az acr build --registry myACR --image devops-api:latest .

# Deploy to AKS
kubectl set image deployment/devops-api-deployment devops-api=myACR.azurecr.io/devops-api:latest
```

---

## 🎓 Learning Outcomes

- DevOps fundamentals: CI/CD, Infrastructure as Code
- Containerization: Docker best practices
- Orchestration: Kubernetes core concepts
- Monitoring: Observability and alerting
- Cloud: Azure/AWS deployment patterns
- Version Control: Git workflow

---

## 📌 Key Features

| Feature | Status | Details |
|---------|--------|----------|
| REST API | ✅ | Node.js with Express.js |
| Docker | ✅ | Multi-stage build, optimized |
| Kubernetes | ✅ | StatelessApp, health checks |
| CI/CD Pipeline | ✅ | GitHub Actions automation |
| Blue-Green Deploy | ✅ | Zero-downtime releases |
| Prometheus Monitoring | ✅ | Custom metrics collection |
| Grafana Dashboards | ✅ | Real-time visualization |
| Cloud Ready | ✅ | AWS & Azure compatible |

---

## 💡 Future Enhancements

- [ ] Helm charts for templated deployments
- [ ] Service mesh (Istio) integration
- [ ] GitOps with ArgoCD
- [ ] Infrastructure-as-code (Terraform)
- [ ] Multi-region deployment
- [ ] Advanced security scanning with Trivy

---

## 📝 License

MIT License

---

## 👤 Author

**Aisha Razzak**
- [GitHub](https://github.com/Aisha-gif2003)
- [LinkedIn](https://linkedin.com/in/aisha-razzak-92b511350)
- [Email](mailto:aisharazzak12@gmail.com)

⭐ **If this project helped you, please star the repository!**
