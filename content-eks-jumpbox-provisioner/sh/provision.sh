#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

CF_STACK_TEMPLATE="/cloudformation/stack.yml"
ENVIRONMENT_NAME=$1

INSTANCE_CONFIG="/config/jumpbox-${ENVIRONMENT_NAME}.sh"

if [ ! -f "${INSTANCE_CONFIG}" ]; then
  echo "No configuration exist at ${INSTANCE_CONFIG}"
  exit 1
else
  source "${INSTANCE_CONFIG}"
fi


aws cloudformation deploy \
  --stack-name "${CF_STACK_NAME}" \
  --region "${AWS_REGION}" \
  --template-file "${CF_STACK_TEMPLATE}" \
  --parameter-overrides \
  SubnetIds="${SUBNET_IDS}" \
  SecurityGroups="${SECURITY_GROUPS}" \
  EnvironmentName="${ENVIRONMENT_NAME}" \
  EnvironmentType="${ENVIRONMENT_TYPE}"

manage-cname-jumpbox.sh "UPSERT"
