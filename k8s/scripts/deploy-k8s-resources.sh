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
kubectl apply -f k8s/base/exoplanets-terminal-job.yaml

echo "Deployment completed successfully."
