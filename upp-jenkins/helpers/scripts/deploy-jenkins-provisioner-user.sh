#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

STACK_RESOURCES_PREFIX="upp-jenkins-test"
CF_STACK_NAME="${STACK_RESOURCES_PREFIX}-provisioner"
CF_STACK_TEMPLATE="../cloudformation/jenkins-provisioner-user.yaml"
AWS_REGION="eu-west-1"

aws cloudformation deploy \
  --stack-name "${CF_STACK_NAME}" \
  --region "${AWS_REGION}" \
  --template-file "${CF_STACK_TEMPLATE}" \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
  stackResourcesPrefix="${STACK_RESOURCES_PREFIX}"
