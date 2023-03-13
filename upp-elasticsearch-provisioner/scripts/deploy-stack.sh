#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

CONFIG_PATH="/config"
ENV_VARS="${CONFIG_PATH}/vars/${CONFIG_NAME}.sh"
if [ ! -f "${ENV_VARS}" ]; then
  echo "No configuration for $CONFIG_NAME exist at ${ENV_VARS}"
  exit 1
else
  # shellcheck source=/dev/null
  source "${ENV_VARS}"
fi

CF_STACK_TEMPLATE="${CONFIG_PATH}/cloudformation/${CF_TEMPLATE}.yaml"
if [ ! -f "${CF_STACK_TEMPLATE}" ]; then
  echo "No CloudFormation template for ${CF_TEMPLATE} exist at ${CONFIG_PATH}/cloudformation"
  exit 1
fi

echo "Create OpenSearch cluster: ${CF_STACK_NAME}"
aws cloudformation deploy \
  --stack-name "${CF_STACK_NAME}" \
  --region "${AWS_REGION}" \
  --template-file "${CF_STACK_TEMPLATE}" \
  --no-fail-on-empty-changeset \
  --parameter-overrides \
  EnvironmentTag="${ENVIRONMENT_TAG}" \
  TeamDLTag="${TEAM_DL_TAG}" \
  SystemCodeTag="${SYSTEM_CODE_TAG}" \
  ClusterName="${CLUSTER_NAME}" \
  BackupRole="${BACKUP_ROLE}" \
  BackupBucketName="${BACKUP_BUCKET}"

source register-snapshot-bucket.sh