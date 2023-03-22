#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

ENVIRONMENT_DESC="Staging"
RESOURCES_PREFIX="upp"

AWS_REGION="eu-west-1"
VPC_ID="vpc-ee57bf89"
CLUSTER_CIDR="10.169.64.0/18"
CLUSTER_CIDR_DESC="FT-Content-Platform-Prod vpc-ee57bf89 CIDR"
RESOURCES_SG_ID="sg-39ef7b40"
RDS_SUBNETS="subnet-024e2e32aefaa01c5, subnet-02526d7213a359f48, subnet-0f2c8a8f1e3db176a"

ENVIRONMENT_TAG="t"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"

CF_STACK_NAME="${RESOURCES_PREFIX}-${CF_TEMPLATE}-${ENVIRONMENT_NAME}"
