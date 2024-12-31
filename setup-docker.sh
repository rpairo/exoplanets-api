#!/bin/bash

docker run -p 8080:8080 \
  -e BASE_URL="https://gist.githubusercontent.com" \
  -e PATH_SEGMENT="/joelbirchler/66cf8045fcbb6515557347c05d789b4a/raw/9a196385b44d4288431eef74896c0512bad3defe" \
  -e ENDPOINT_EXOPLANETS="/exoplanets" \
  rpairo/exoplanets-api:latest