#!/bin/bash
# Provisions ACR + AKS via Bicep, then builds/pushes the image and deploys to AKS.
# Usage: ./infra/deploy-aks.sh <resource-group> <image-tag>

set -e

RESOURCE_GROUP="${1:?Usage: deploy-aks.sh <resource-group> <image-tag>}"
IMAGE_TAG="${2:?Usage: deploy-aks.sh <resource-group> <image-tag>}"

echo "Deploying infrastructure (ACR + AKS)..."
az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file infra/main.bicep \
  --query properties.outputs -o json > /tmp/aks-outputs.json

ACR_LOGIN_SERVER=$(jq -r '.acrLoginServer.value' /tmp/aks-outputs.json)
ACR_NAME=$(jq -r '.acrName.value' /tmp/aks-outputs.json)
AKS_CLUSTER_NAME=$(jq -r '.aksClusterName.value' /tmp/aks-outputs.json)

echo "Building Docker image..."
docker build -t "$ACR_LOGIN_SERVER/devops-cloud-project:$IMAGE_TAG" .

echo "Logging in to ACR..."
az acr login --name "$ACR_NAME"

echo "Pushing image to $ACR_LOGIN_SERVER..."
docker push "$ACR_LOGIN_SERVER/devops-cloud-project:$IMAGE_TAG"

echo "Fetching AKS credentials..."
az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$AKS_CLUSTER_NAME" --overwrite-existing

echo "Deploying manifests..."
sed -e "s|__ACR_LOGIN_SERVER__|$ACR_LOGIN_SERVER|g" -e "s|__IMAGE_TAG__|$IMAGE_TAG|g" node-app.yaml | kubectl apply -f -
kubectl apply -f my-ingress.yaml

echo "Done. Checking status..."
kubectl get pods
kubectl get svc
