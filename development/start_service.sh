#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <service-name>"
  exit 1
fi

SERVICE_NAME=$1
NAMESPACE="atlas"

kubectl scale deployment $SERVICE_NAME -n $NAMESPACE --replicas=1
