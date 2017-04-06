#!/usr/bin/env bash

source $(dirname $0)/functions.sh || echo "Failed to source functions.sh"

usage() {
  info "$0 --environment=envname --key_kon_dns=konstructor_dns_api_key"
  exit 0
}

processCliArgs $*

[[ -z ${ARGS[--environment]} ]] && usage
[[ -z ${ARGS[--key_kon_dns]} ]] && usage
echo "Creating stack for environment ${ARGS[--environment]}"

read -r -d '' CF_PARAMS <<EOM
[
    {
        "ParameterKey": "KonstructorAPIKey",
        "ParameterValue": "${ARGS[--key_kon_dns]}",
        "UsePreviousValue": false
    }
]
EOM

CWD=$(pwd) #Make note of current work directory
cd $(dirname $0) #Change dir to repository root
aws cloudformation create-stack --stack-name=up-jump-${ARGS[--environment]} --template-body=file://../cloudformation/jumpbox.yaml --parameters="${CF_PARAMS}"
cd ${CWD} #Go back to original work directory
