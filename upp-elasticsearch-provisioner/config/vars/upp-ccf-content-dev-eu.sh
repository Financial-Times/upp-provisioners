#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

RESOURCES_PREFIX="upp"
CF_TEMPLATE="ccf-content"
ENVIRONMENT_NAME="dev-eu"

AWS_REGION="eu-west-1"

ENVIRONMENT_TAG="d"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"

CF_STACK_NAME="${RESOURCES_PREFIX}-${CF_TEMPLATE}-${ENVIRONMENT_NAME}"

BACKUP_ROLE="upp-elasticsearch-backup-role"
BACKUP_BUCKET="${CLUSTER_NAME}-backup"