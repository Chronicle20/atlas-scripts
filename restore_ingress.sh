#!/bin/bash

NAMESPACE="atlas"
INGRESS_DEPLOYMENT="atlas-ingress"

echo "Restoring ConfigMap..."
kubectl apply -f ~/source/k3s/atlas/atlas-configmap.yml

echo "Restarting $INGRESS_DEPLOYMENT..."
kubectl rollout restart deployment $INGRESS_DEPLOYMENT -n $NAMESPACE
