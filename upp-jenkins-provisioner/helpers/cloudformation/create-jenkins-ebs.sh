#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

CONFIG_PATH="../../config"
JENKINS_CONFIG="${CONFIG_PATH}/vars/${JENKINS_UID}.sh"

if [ ! -f "${JENKINS_CONFIG}" ]; then
  echo "No configuration for $JENKINS_UID exist at ${JENKINS_CONFIG}"
  exit 1
else
  # shellcheck source=/dev/null
  source "${JENKINS_CONFIG}"
fi


RESOURCES_PREFIX="upp-test"
CF_STACK_NAME="${RESOURCES_PREFIX}-jenkins-${JENKINS_UID}-ebs"
CF_STACK_TEMPLATE="./jenkins-ebs.yaml"
AWS_REGION="eu-west-1"

aws cloudformation deploy \
  --stack-name "${CF_STACK_NAME}" \
  --region "${AWS_REGION}" \
  --template-file "${CF_STACK_TEMPLATE}" \
  --no-fail-on-empty-changeset \
  --parameter-overrides \
  jenkinsUid="${JENKINS_UID}" \
  stackResourcesPrefix="${RESOURCES_PREFIX}"
