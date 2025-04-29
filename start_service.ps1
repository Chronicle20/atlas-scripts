param (
    [string]$ServiceName
)

if (-not $ServiceName) {
    Write-Host "Usage: start_service.ps1 <service-name>"
    exit 1
}

$Namespace = "atlas"
kubectl scale deployment $ServiceName -n $Namespace --replicas=1
