#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

### Global
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"
ENVIRONMENT_TAG="d"

RESOURCES_PREFIX="upp"
AWS_REGION="eu-west-1"
VPC_ID="vpc-f75fb790"
VPC_CIDR_1="10.172.32.0/21"
VPC_CIDR_2="10.169.0.0/18"

SUBNET_ID_A="subnet-0d1ca6b04133a3ad2"
SUBNET_ID_B="subnet-020bff57b77ad7438"
SUBNET_ID_C="subnet-048030b5219e45d9b"

DOC_DB_CLUSTER_ENGINE_VERSION="4.0.0"
DOC_DB_CLUSTER_BACKUP_RETENTION_PERIOD="1"
### https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html
DOC_DB_INSTANCE_CLASS="db.t3.medium"
DOC_DB_INSTANCE_SECOND="disable"
DOC_DB_INSTANCE_THIRD="disable"
