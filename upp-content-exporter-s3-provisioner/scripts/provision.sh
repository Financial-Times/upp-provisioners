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

STACK_TEMPLATE="/config/cloudformation/upp-full-content-exporter-s3.yml"
STACK_NAME="upp-full-content-exporter-s3-${ENVIRONMENT_NAME}"

aws cloudformation deploy \
  --template-file "${STACK_TEMPLATE}" \
  --stack-name "${STACK_NAME}" \
  --region "${AWS_REGION}" \
  --parameter-overrides \
  BucketName="${BUCKET_NAME}" \
  EnvType="${ENV_TYPE}" \
  SystemCode="${SYSTEM_CODE}" \
  TeamDL="${TEAM_DL}"
