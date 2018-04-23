#!/bin/bash

cd /ansible

ansible-playbook provision.yml --extra-vars "\
environment_tag=${ENVIRONMENT_TAG} \
aws_default_region=${AWS_DEFAULT_REGION} \
environment_type=${ENVIRONMENT_TYPE} \
is_multi_region=${IS_MULTI_REGION} \
aws_secondary_region=${AWS_SECONDARY_REGION} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} \
sqs_concept_max_depth=${SQS_CONCEPT_MAX_DEPTH}"
