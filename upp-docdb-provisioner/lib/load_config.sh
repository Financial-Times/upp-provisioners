#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

CONFIG_PATH="/config"
INSTANCE_CONFIG="${CONFIG_PATH}/vars/${INSTANCE_UID}.sh"

if [ ! -f "${INSTANCE_CONFIG}" ]; then
  echo "No configuration for ${INSTANCE_UID} exist at ${INSTANCE_CONFIG}"
  exit 1
else
  set -o allexport
  # shellcheck source=/dev/null
  source "${INSTANCE_CONFIG}"
  set +o allexport
fi

