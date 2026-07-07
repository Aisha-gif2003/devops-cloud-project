# Blue-Green traffic switch
# Usage: .\switch.ps1 blue|green   (no arg = show current live environment)
param([string]$Target)

$current = kubectl get svc nodejs-bg-service -o jsonpath='{.spec.selector.version}'

if (-not $Target) {
    Write-Host "Currently LIVE: $current" -ForegroundColor $current
    exit 0
}

if ($Target -ne "blue" -and $Target -ne "green") {
    Write-Host "Usage: .\switch.ps1 blue|green" -ForegroundColor Red
    exit 1
}

if ($Target -eq $current) {
    Write-Host "$Target is already live." -ForegroundColor Yellow
    exit 0
}

Write-Host "Switching traffic: $current -> $Target ..." -ForegroundColor Cyan
kubectl patch svc nodejs-bg-service -p ('{\"spec\":{\"selector\":{\"app\":\"nodejs-app\",\"version\":\"' + $Target + '\"}}}')

Write-Host "Done. ALL traffic now goes to $Target." -ForegroundColor Green
Write-Host "Rollback anytime with: .\switch.ps1 $current"
