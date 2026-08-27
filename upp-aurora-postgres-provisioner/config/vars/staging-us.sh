#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

ENVIRONMENT_DESC="Staging"
RESOURCES_PREFIX="upp"

AWS_REGION="us-east-1"
VPC_ID="vpc-4bc03f32"
CLUSTER_CIDR="10.168.64.0/18"
CLUSTER_CIDR_DESC="FT-Content-Platform-Prod vpc-4bc03f32 CIDR"
RESOURCES_SG_ID="sg-a0e39ade"
RDS_SUBNETS="subnet-0ef54f5f927721d15, subnet-0c18f15e56e0490c6, subnet-0ef8d475f498f5928"

ENVIRONMENT_TAG="t"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"

CF_STACK_NAME="${RESOURCES_PREFIX}-${CF_TEMPLATE}-${ENVIRONMENT_NAME}"
