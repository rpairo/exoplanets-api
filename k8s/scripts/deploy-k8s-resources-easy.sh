#!/bin/bash

echo "Creating secrets manually..."
./k8s/scripts/create-k8s-secrets-manual.sh

echo "Cleaning Kubernetes resources..."
kubectl delete deployment exoplanets-api-deployment
kubectl delete service exoplanets-api-service

echo "Deploying Kubernetes resources..."
kubectl apply -f k8s/base/exoplanets-api-deployment.yaml
echo "Deployment completed successfully."

echo "Setting up local 'NodePort' configuration and port-forwarding."
kubectl apply -f k8s/base/exoplanets-api-local-service.yaml

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