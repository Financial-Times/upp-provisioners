#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

REPO_ROOTDIR="../.."

MAKE_COMMAND=${1:-"shell"}

set +u
if [[ -n ${AWS_PROFILE} ]]; then
  AWS_ACCESS_KEY_ID="$(aws --profile "$AWS_PROFILE" configure get aws_access_key_id)"
  AWS_SECRET_ACCESS_KEY="$(aws --profile "$AWS_PROFILE" configure get aws_secret_access_key)"
fi
set -u

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export JENKINS_UID

cd ${REPO_ROOTDIR}

# NOTE: If you develop/debug and iterate often comment the "make rebuild" and
# uncomment "make rebuild-files"
# make rebuild-files
make rebuild

make "${MAKE_COMMAND}"
