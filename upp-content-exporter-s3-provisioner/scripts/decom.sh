#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

CONFIG="/config/vars/${ENVIRONMENT_NAME}.sh"

if [ ! -f "${CONFIG}" ]; then
  echo "No configuration for $ENVIRONMENT_NAME exists at ${CONFIG}"
  exit 1
else
  # shellcheck source=/dev/null
  source "${CONFIG}"
fi

STACK_NAME="upp-full-content-exporter-s3-${ENVIRONMENT_NAME}"

aws cloudformation delete-stack \
  --region "${AWS_REGION}" \
  --stack-name "${STACK_NAME}"

aws cloudformation wait stack-delete-complete \
  --region "${AWS_REGION}" \
  --stack-name "${STACK_NAME}"
