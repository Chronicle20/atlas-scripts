#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <service-name> <replacement-host/ip>"
  exit 1
fi

SERVICE_NAME=$1
REPLACEMENT=$2

CONFIGMAP_NAME="atlas-ingress-configmap"
NAMESPACE="atlas"
INGRESS_DEPLOYMENT="atlas-ingress"

echo "Fetching existing ConfigMap..."
kubectl get configmap $CONFIGMAP_NAME -n $NAMESPACE -o yaml > /tmp/configmap.yml

echo "Updating ConfigMap to reroute $SERVICE_NAME to $REPLACEMENT..."
sed -i "s#proxy_pass http://$SERVICE_NAME\.$NAMESPACE\.svc\.cluster\.local:8080#proxy_pass http://$REPLACEMENT#g" /tmp/configmap.yml

echo "Applying updated ConfigMap..."
kubectl apply -f /tmp/configmap.yml

echo "Restarting $INGRESS_DEPLOYMENT..."
kubectl rollout restart deployment $INGRESS_DEPLOYMENT -n $NAMESPACE
