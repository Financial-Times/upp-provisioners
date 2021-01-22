#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

repo_rootdir="../.."
secrets_env_file="./${INSTANCE_UID}-secrets.env"
make_command=${1:-"shell"}

set +u
if [[ -n ${AWS_PROFILE} ]]; then
  AWS_ACCESS_KEY_ID="$(aws --profile "$AWS_PROFILE" configure get aws_access_key_id)"
  AWS_SECRET_ACCESS_KEY="$(aws --profile "$AWS_PROFILE" configure get aws_secret_access_key)"
fi
set -u

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export INSTANCE_UID


if [ ! -f "${secrets_env_file}" ]; then
  echo "No env configuration for ${INSTANCE_UID} exist: ${secrets_env_file}"
  exit 1
else
  set -o allexport
  # shellcheck source=/dev/null
  source "${secrets_env_file}"
  set +o allexport
fi

cd ${repo_rootdir}

### NOTE: If you develop/debug and iterate often comment the "make rebuild" and
### uncomment "make rebuild-files"
# make rebuild-files
make rebuild

make "${make_command}"
