#!/bin/bash

cd /ansible

ansible-playbook decom.yml --extra-vars "\
environment_type=${ENVIRONMENT_TYPE} \
aws_region=${AWS_REGION} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} "
