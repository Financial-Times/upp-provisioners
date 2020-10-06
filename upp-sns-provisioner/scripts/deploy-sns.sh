#!/usr/bin/env bash
# Strict Mode - http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

 if [ "$#" -ne  "2" ]
   then
     echo "Two arguments are needed"
     echo "deploy-sns.sh <CLOUDFORMATION_TEMPLATE_FILE> <CLOUDFORMATION_STACK_NAME>"
     exit 1
 fi

TEMPLATE_FILE=$1
STACK_NAME=$2

aws cloudformation deploy \
  --template-file "${TEMPLATE_FILE}" \
  --stack-name "${STACK_NAME}"
