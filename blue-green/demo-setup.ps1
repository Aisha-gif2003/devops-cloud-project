# One-command blue-green demo setup on Minikube
# Prereq: Docker Desktop running. Run from the repo root: .\blue-green\demo-setup.ps1

Write-Host "`n[1/5] Starting Minikube..." -ForegroundColor Yellow
minikube status | Out-Null
if ($LASTEXITCODE -ne 0) { minikube start }

Write-Host "`n[2/5] Building Docker image..." -ForegroundColor Yellow
docker build -t devops-cloud-project:latest .
if ($LASTEXITCODE -ne 0) { Write-Host "Docker build failed" -ForegroundColor Red; exit 1 }

Write-Host "`n[3/5] Loading image into Minikube..." -ForegroundColor Yellow
minikube image load devops-cloud-project:latest

Write-Host "`n[4/5] Deploying BLUE + GREEN environments and the service..." -ForegroundColor Yellow
kubectl apply -f .\blue-green\deployment-blue.yaml
kubectl apply -f .\blue-green\deployment-green.yaml
kubectl apply -f .\blue-green\service.yaml

Write-Host "`n[5/5] Waiting for pods..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=nodejs-app --timeout=180s
kubectl get pods -l app=nodejs-app

Write-Host "`nDemo ready! Open the app with:" -ForegroundColor Green
Write-Host "  minikube service nodejs-bg-service --url" -ForegroundColor Cyan
Write-Host "`nThen flip traffic live:" -ForegroundColor Green
Write-Host "  .\blue-green\switch.ps1 green    # blue -> green"
Write-Host "  .\blue-green\switch.ps1 blue     # instant rollback"
