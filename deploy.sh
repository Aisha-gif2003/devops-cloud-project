#!/bin/bash

# DevOps Cloud Project - Complete Deployment Script
# Usage: ./deploy.sh

set -e  # Exit on error

echo "🚀 Starting DevOps Cloud Project Deployment..."
echo ""

# Step 1: Start Minikube
echo "📦 Step 1: Starting Minikube..."
minikube start --driver=docker || echo "Minikube already running"
sleep 5

# Step 2: Enable Ingress
echo "🌐 Step 2: Enabling Ingress addon..."
minikube addons enable ingress
sleep 3

# Step 3: Set Docker environment
echo "🐳 Step 3: Setting Docker environment..."
& minikube -p minikube docker-env --shell powershell | Invoke-Expression || eval $(minikube docker-env)

# Step 4: Build Docker image
echo "🔨 Step 4: Building Docker image..."
docker build -t devops-cloud-project:latest .
sleep 2

# Step 5: Load image to Minikube
echo "📥 Step 5: Loading image to Minikube..."
minikube image load devops-cloud-project:latest

# Step 6: Apply Kubernetes manifests
echo "☸️  Step 6: Deploying to Kubernetes..."
kubectl apply -f node-app.yaml
kubectl apply -f my-ingress.yaml

# Step 7: Wait for pods
echo "⏳ Step 7: Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=nodejs-app --timeout=300s

# Step 8: Get info
echo ""
echo "✅ DEPLOYMENT COMPLETE!"
echo ""
echo "📊 Cluster Info:"
kubectl get pods
echo ""
kubectl get svc
echo ""
kubectl get ingress

# Step 9: Access info
MINIKUBE_IP=$(minikube ip)
echo ""
echo "🌍 Access Your App:"
echo "  Port-Forward: kubectl port-forward svc/nodejs-service 3000:3000"
echo "  Then visit: http://localhost:3000"
echo ""
echo "  Ingress: http://node-app.local"
echo "  (Add to hosts: $MINIKUBE_IP node-app.local)"
echo ""
echo "🎉 Happy DevOps-ing!"