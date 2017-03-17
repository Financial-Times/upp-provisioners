#!/bin/bash
set -x
set -e

echo "Running playbook rdsserver.yml"

ansible-playbook -vvv rdsserver.yml \
--extra-vars \
"environment_name=$ENV_NAME konstructor_api_key=$KON_API_KEY"
