#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

ENVIRONMENT_DESC="Dev"
RESOURCES_PREFIX="upp"

AWS_REGION="eu-west-1"
VPC_ID="vpc-f75fb790"
RESOURCES_SG_ID="sg-8bcb5ff2"
RDS_SUBNETS="subnet-020bff57b77ad7438, subnet-0d1ca6b04133a3ad2, subnet-048030b5219e45d9b"

ENVIRONMENT_TAG="d"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"

CF_STACK_NAME="${RESOURCES_PREFIX}-ontotext-backup-rds-${ENVIRONMENT_NAME}"
