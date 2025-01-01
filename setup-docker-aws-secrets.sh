#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install AWS CLI to proceed."
    exit 1
fi

# Configure AWS CLI if necessary
echo "Configuring AWS CLI..."
aws configure

# Define the secret name and AWS region
SECRET_NAME="exoplanets-analyzer-api-url-prod"
AWS_REGION="us-west-2"

# Retrieve the secret value
secrets=$(aws secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --region "$AWS_REGION" \
  --query SecretString \
  --output text)

# Check if 'jq' is installed for JSON parsing
if ! command -v jq &> /dev/null; then
    echo "'jq' is not installed. Please install it to proceed."
    exit 1
fi

# Extract variables from the JSON secret using 'jq'
BASE_URL=$(echo "$secrets" | jq -r '.BASE_URL')
PATH_SEGMENT=$(echo "$secrets" | jq -r '.PATH_SEGMENT')
ENDPOINT_EXOPLANETS=$(echo "$secrets" | jq -r '.ENDPOINT_EXOPLANETS')
GOOGLE_API_KEY=$(echo "$secrets" | jq -r '.GOOGLE_API_KEY')
GOOGLE_SEARCH_ENGINE_ID=$(echo "$secrets" | jq -r '.GOOGLE_SEARCH_ENGINE_ID')

# Verify that all variables were successfully retrieved
if [ -z "$BASE_URL" ] || [ -z "$PATH_SEGMENT" ] || [ -z "$ENDPOINT_EXOPLANETS" ] || [ -z "$GOOGLE_API_KEY" ] || [ -z "$GOOGLE_SEARCH_ENGINE_ID" ]; then
    echo "Error retrieving one or more variables from the secret."
    exit 1
fi

# Run the Docker container with the environment variables
docker run -p 8080:8080 \
  -e BASE_URL="$BASE_URL" \
  -e PATH_SEGMENT="$PATH_SEGMENT" \
  -e ENDPOINT_EXOPLANETS="$ENDPOINT_EXOPLANETS" \
  -e GOOGLE_API_KEY="$GOOGLE_API_KEY" \
  -e GOOGLE_SEARCH_ENGINE_ID="$GOOGLE_SEARCH_ENGINE_ID" \
  rpairo/exoplanets-api:latest
