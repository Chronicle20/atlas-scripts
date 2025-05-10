$Namespace = "atlas"
$IngressDeployment = "atlas-ingress"

Write-Host "Restoring ConfigMap..."
kubectl apply -f "$env:USERPROFILE\source\k3s\atlas\atlas-configmap.yml"

Write-Host "Restarting $IngressDeployment..."
kubectl rollout restart deployment $IngressDeployment -n $Namespace
