#!/usr/bin/env bash

set -x

cd /ansible || exit

ansible-playbook delete.yml --extra-vars "\
aws_region=${AWS_REGION} \
aws_access_key=${AWS_ACCESS_KEY_ID} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} \
cluster_name=${CLUSTER_NAME} \
environment_type=${ENVIRONMENT_TYPE}"
