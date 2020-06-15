#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

JENKINS_UID="$1" # e.g. master-test
AWS_PROFILE="$2" # e.g. upp-jenkins-provisioner-test
COMMAND=${3:-"shell"}  # e.g. create-ami

ROOT_DIR="../.."
AWS_ACCESS_KEY_ID="$(aws --profile "$AWS_PROFILE" configure get aws_access_key_id)"
AWS_SECRET_ACCESS_KEY="$(aws --profile "$AWS_PROFILE" configure get aws_secret_access_key)"

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export JENKINS_UID

cd "${ROOT_DIR}"

make rebuild-files
make "${COMMAND}"
