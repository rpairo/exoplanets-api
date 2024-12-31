#!/bin/bash

if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install AWS CLI to proceed."
    exit 1
fi

echo "Configuring AWS CLI..."
aws configure

SECRET_NAME="exoplanets-analyzer-api-url-prod"
AWS_REGION="us-west-2"

secrets=$(aws secretsmanager get-secret-value \
  --secret-id $SECRET_NAME \
  --region $AWS_REGION \
  --query SecretString \
  --output text)

BASE_URL=$(echo "$secrets" | grep -o '"BASE_URL":"[^"]*' | sed 's/"BASE_URL":"//')
PATH_SEGMENT=$(echo "$secrets" | grep -o '"PATH_SEGMENT":"[^"]*' | sed 's/"PATH_SEGMENT":"//')
ENDPOINT_EXOPLANETS=$(echo "$secrets" | grep -o '"ENDPOINT_EXOPLANETS":"[^"]*' | sed 's/"ENDPOINT_EXOPLANETS":"//')

docker run -p 8080:8080 \
  -e BASE_URL="$BASE_URL" \
  -e PATH_SEGMENT="$PATH_SEGMENT" \
  -e ENDPOINT_EXOPLANETS="$ENDPOINT_EXOPLANETS" \
  rpairo/exoplanets-api:latest
