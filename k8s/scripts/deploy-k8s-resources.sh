#!/bin/bash

current_context=$(kubectl config current-context)

if [[ "$current_context" == "docker-desktop" ]]; then
  echo "Running on Docker Desktop. Proceeding with secrets creation..."

  if command -v aws &> /dev/null; then
    echo "AWS CLI found. Creating secrets from AWS..."
    ./k8s/scripts/create-k8s-secrets-from-aws.sh
  else
    echo "AWS CLI not found. Creating secrets manually..."
    ./k8s/scripts/create-k8s-secrets-manual.sh
  fi

else
  echo "Not running on Docker Desktop. Skipping secrets creation."
fi

echo "Deploying Kubernetes resources..."

kubectl delete deployment exoplanets-api-deployment
kubectl delete service exoplanets-api-service

kubectl apply -f k8s/base/exoplanets-api-deployment.yaml
kubectl apply -f k8s/base/exoplanets-api-service.yaml

echo "Deployment completed successfully."
