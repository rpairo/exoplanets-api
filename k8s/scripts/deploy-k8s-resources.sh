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
  echo "I haven't been able to test in real cluster environment, I haven't been able to test properly the aws secrets integration."
  echo "Since I haven't been able to test it, we will set up the credentials manually in this ocassion."
  echo "AWS CLI not found. Creating secrets manually..."
  ./k8s/scripts/create-k8s-secrets-manual.sh
fi

echo "Cleaning Kubernetes resources..."
kubectl delete deployment exoplanets-api-deployment
kubectl delete service exoplanets-api-service

echo "Deploying Kubernetes resources..."
kubectl apply -f k8s/base/exoplanets-api-deployment.yaml
echo "Deployment completed successfully."

if [[ "$current_context" == "docker-desktop" ]]; then
  echo "Running on Docker Desktop. Setting up local 'NodePort' configuration and port-forwarding."
  kubectl apply -f k8s/base/exoplanets-api-local-service.yaml

  echo "Checking if service 'exoplanets-api-service' is ready..."

  while true; do
    ready_pods=$(kubectl get pods --selector=app=exoplanets-api --field-selector=status.phase=Running --no-headers | wc -l)
    if [[ "$ready_pods" -ge 1 ]]; then
      echo "Service is ready. Proceeding with port-forwarding..."
      break
    fi
    echo "Service not ready yet. Retrying in 2 seconds..."
    sleep 2
  done
  kubectl port-forward service/exoplanets-api-service 8080:80
else
  kubectl apply -f k8s/base/exoplanets-api-cluster-service.yaml
fi
