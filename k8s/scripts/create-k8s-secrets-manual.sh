#!/bin/bash

echo "Creating secrets manually..."

SECRET_NAME="exoplanets-local-secrets"

kubectl delete secret "$SECRET_NAME" --ignore-not-found

BASE_URL_DECODING=$(echo "aHR0cHM6Ly9naXN0LmdpdGh1YnVzZXJjb250ZW50LmNvbQ==" | base64 --decode)
PATH_SEGMENT_DECODING=$(echo "L2pvZWxiaXJjaGxlci82NmNmODA0NWZjYmI2NTE1NTU3MzQ3YzA1ZDc4OWI0YS9yYXcvOWExOTYzODViNDRkNDI4ODQzMWVlZjc0ODk2YzA1MTJiYWQzZGVmZQ==" | base64 --decode)
ENDPOINT_EXOPLANETS_DECODING=$(echo "L2V4b3BsYW5ldHM=" | base64 --decode)
GOOGLE_API_KEY_DECODING=$(echo "QUl6YVN5QVZLR2p0T09BeWpTbF9TRklhamk2eTg3eTR1UG5KYy1F" | base64 --decode)
GOOGLE_SEARCH_ENGINE_ID_DECODING=$(echo "ZjA4ZDkxNTg0NDg5YzQ1Mzc=" | base64 --decode)

kubectl create secret generic "$SECRET_NAME" \
  --from-literal=BASE_URL="$BASE_URL_DECODING" \
  --from-literal=PATH_SEGMENT="$PATH_SEGMENT_DECODING" \
  --from-literal=ENDPOINT_EXOPLANETS="$ENDPOINT_EXOPLANETS_DECODING" \
  --from-literal=GOOGLE_API_KEY="$GOOGLE_API_KEY_DECODING" \
  --from-literal=GOOGLE_SEARCH_ENGINE_ID="$GOOGLE_SEARCH_ENGINE_ID_DECODING"

echo "Kubernetes secret '$SECRET_NAME' created successfully."
