# 🚀 DevOps Cloud Project - Production-Ready Kubernetes Deployment

A **complete, enterprise-grade Node.js application** deployed on Kubernetes with Docker, monitoring, and CI/CD pipeline.

---

## 📋 Project Overview

This project demonstrates a **full-stack DevOps workflow**:
- ✅ Node.js REST API (Express.js)
- ✅ Docker containerization
- ✅ Kubernetes orchestration (Minikube)
- ✅ Prometheus + Grafana monitoring
- ✅ Ingress networking
- ✅ Persistent storage
- ✅ One-click deployment script

---

## 🏗️ Architecture
┌─────────────┐
│ Node.js App │
└──────┬──────┘
│
┌──────▼──────┐
│ Docker │
└──────┬──────┘
│
┌──────▼──────────────┐
│ Kubernetes │
│ (Minikube) │
│ ┌────────────────┐ │
│ │ Pod (Running) │ │
│ │ Service (3000) │ │
│ │ Ingress │ │
│ └────────────────┘ │
└──────┬──────────────┘
│
┌──────▼─────────────┐
│ Monitoring Stack │
│ Prometheus/Grafana │
└────────────────────┘


---

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed
- Minikube installed
- kubectl installed
- PowerShell (Windows)

### One-Command Deployment

```powershell
cd C:\devops-cloud-project
.\deploy.ps1




