#!/bin/bash

ENVIRONMENT_NAME=$1

INSTANCE_CONFIG="/config/rosette-${ENVIRONMENT_NAME}.sh"

if [ ! -f "${INSTANCE_CONFIG}" ]; then
  echo "No configuration exist at ${INSTANCE_CONFIG}"
  exit 1
else
  source "${INSTANCE_CONFIG}"
fi



aws cloudformation  delete-stack \
  --stack-name "${CF_STACK_NAME}"
