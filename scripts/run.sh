#!/bin/bash

: "${NGINX_PORT:=8443}" "${SHIM_PORT:=3001}" "${FIL_WALLET_ADDRESS:=dev}"

echo "running gateway station with nginx @ ${NGINX_PORT} and shim @ ${SHIM_PORT}"

# Start the docker image
docker run --rm -it \
          -e FIL_WALLET_ADDRESS=$FIL_WALLET_ADDRESS \
          -e SHIM_PORT=$SHIM_PORT -e NGINX_PORT=$NGINX_PORT \
          -p $SHIM_PORT:$SHIM_PORT -p $NGINX_PORT:$NGINX_PORT \
          gateway
