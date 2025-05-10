param (
    [string]$ServiceName,
    [string]$Replacement
)

if (-not $ServiceName -or -not $Replacement) {
    Write-Host "Usage: debug_service.ps1 <service-name> <replacement-host/ip>"
    exit 1
}

$ConfigMapName = "atlas-ingress-configmap"
$Namespace = "atlas"
$IngressDeployment = "atlas-ingress"

Write-Host "Fetching existing ConfigMap..."
kubectl get configmap $ConfigMapName -n $Namespace -o yaml > "$env:TEMP\configmap.yml"

Write-Host "Updating ConfigMap to reroute $ServiceName to $Replacement..."
(Get-Content "$env:TEMP\configmap.yml") -replace "proxy_pass http://$ServiceName\.atlas\.svc\.cluster\.local:8080", "proxy_pass http://$Replacement" | Set-Content "$env:TEMP\configmap.yml"

Write-Host "Applying updated ConfigMap..."
kubectl apply -f "$env:TEMP\configmap.yml"

Write-Host "Restarting $IngressDeployment..."
kubectl rollout restart deployment $IngressDeployment -n $Namespace
