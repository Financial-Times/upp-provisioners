#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

AWS_REGION="eu-west-1"
BUCKET_NAME="com.ft.universalpublishing.enrichedcontentdata.full.k8s-test"

ENV_TYPE="d"
SYSTEM_CODE="upp"
TEAM_DL="universal.publishing.platform@ft.com"
