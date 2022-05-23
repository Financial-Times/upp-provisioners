#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

ENVIRONMENT_DESC="Prod"
RESOURCES_PREFIX="upp"

AWS_REGION="eu-west-1"
VPC_ID="vpc-ee57bf89"
EU_CLUSTER_CIDR="10.169.64.0/18"
EU_CLUSTER_CIDR_DESC="FT-Content-Platform-Prod-EU vpc-ee57bf89 CIDR"
US_CLUSTER_CIDR="10.168.64.0/18"
US_CLUSTER_CIDR_DESC="FT-Content-Platform-Prod-US vpc-4bc03f32 CIDR"
RESOURCES_SG_ID="sg-39ef7b40"
RDS_SUBNETS="subnet-024e2e32aefaa01c5, subnet-02526d7213a359f48, subnet-0f2c8a8f1e3db176a"

ENVIRONMENT_TAG="p"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"

CF_STACK_NAME="${RESOURCES_PREFIX}-ontotext-backup-rds-${ENVIRONMENT_NAME}"
