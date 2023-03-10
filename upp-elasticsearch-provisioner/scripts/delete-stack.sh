#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

CONFIG_PATH="/config"
CF_STACK_TEMPLATE="${CONFIG_PATH}/cloudformation/${CF_TEMPLATE}.yaml"
ENV_VARS="${CONFIG_PATH}/vars/${ENVIRONMENT_NAME}.sh"

if [ ! -f "${ENV_VARS}" ]; then
  echo "No configuration for $ENVIRONMENT_NAME exist at ${ENV_VARS}"
  exit 1
else
  # shellcheck source=/dev/null
  source "${ENV_VARS}"
fi

if [ ! -f "${CF_STACK_TEMPLATE}" ]; then
  echo "No CloudFormation template for ${CF_TEMPLATE} exist at ${CONFIG_PATH}/cloudformation"
  exit 1
fi

aws cloudformation delete-stack \
  --region "${AWS_REGION}" \
  --stack-name "${CF_STACK_NAME}"

echo "Waiting for the ${CF_STACK_NAME} stack to finish deleting."
aws cloudformation wait stack-delete-complete \
  --region "${AWS_REGION}" \
  --stack-name "${CF_STACK_NAME}"