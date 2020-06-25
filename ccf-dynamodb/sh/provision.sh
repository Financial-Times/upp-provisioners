#!/bin/bash

cd /ansible

ansible-playbook provision.yml --extra-vars "\
aws_access_key_id=${AWS_ACCESS_KEY_ID} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} \
aws_region=${AWS_REGION} \
environment_name=${ENVIRONMENT_NAME} \
environment_type=${ENVIRONMENT_TYPE}"
