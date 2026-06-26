Write-Host "`n🚀 Starting DevOps Cloud Project Deployment..." -ForegroundColor Cyan

# Step 1: Start Minikube
Write-Host "`n📦 Step 1: Starting Minikube..." -ForegroundColor Yellow
minikube status | Out-Null
if ($LASTEXITCODE -ne 0) {
    minikube start
}

# Step 2: Enable ingress addon
Write-Host "`n🌐 Step 2: Enabling Ingress addon..." -ForegroundColor Yellow
minikube addons enable ingress

# Step 3: Build Docker image
Write-Host "`n🐳 Step 3: Building Docker image..." -ForegroundColor Yellow
docker build -t devops-cloud-project:latest .

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n❌ Docker build failed, aborting." -ForegroundColor Red
    exit 1
}

# Step 4: Apply Kubernetes manifests
Write-Host "`n☸️  Step 4: Applying Kubernetes manifests..." -ForegroundColor Yellow
kubectl apply -f .\k8s\

# Step 5: Apply monitoring manifests (optional, ignore errors)
Write-Host "`n📊 Step 5: Applying monitoring manifests (if any)..." -ForegroundColor Yellow
if (Test-Path .\monitoring) {
    kubectl apply -f .\monitoring\ 2>$null
}

# Step 6: Status check
Write-Host "`n✅ Step 6: Checking pod & service status..." -ForegroundColor Yellow
kubectl get pods
kubectl get svc

Write-Host "`n🌍 Access (Minikube):" -ForegroundColor Cyan
Write-Host "  minikube service nodejs-service --url`n" -ForegroundColor Cyan

Write-Host "`n✅ DEPLOYMENT COMPLETE!" -ForegroundColor Green