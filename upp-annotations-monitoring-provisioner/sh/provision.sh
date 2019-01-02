#!/bin/bash

cd /ansible

ansible-playbook provision.yml --extra-vars "\
aws_access_key_id=${AWS_ACCESS_KEY_ID} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} \
aws_region=${AWS_REGION} \
cluster=${CLUSTER} \
environment_type=${ENVIRONMENT_TYPE} \
input_kinesis_stream_arn=${INPUT_KINESIS_STREAM_ARN} \
input_role_arn=${INPUT_ROLE_ARN} "
