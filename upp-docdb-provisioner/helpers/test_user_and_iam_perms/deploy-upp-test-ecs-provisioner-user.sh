#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

### Put the repo path on your workstation. Below is an example:
AWS_COMPOSER_ACCOUNT_REPO="/Users/bboykov/wd/ft/aws-composer-account-content-platform-test"

STACK_RESOURCES_PREFIX="upp-docdb-test"
CF_STACK_NAME="${STACK_RESOURCES_PREFIX}-provisioner"
CF_STACK_TEMPLATE="${AWS_COMPOSER_ACCOUNT_REPO}/cloudformation/k8s/iam/upp-docdb-provisioner-user.yaml"
AWS_REGION="eu-west-1"

aws cloudformation deploy \
  --stack-name "${CF_STACK_NAME}" \
  --region "${AWS_REGION}" \
  --template-file "${CF_STACK_TEMPLATE}" \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
  stackResourcesPrefix="${STACK_RESOURCES_PREFIX}"
