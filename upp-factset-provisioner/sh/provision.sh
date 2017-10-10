#!/bin/bash

cd /ansible

ansible-playbook provision.yml --extra-vars "\
aws_access_key=${ACCESS_KEY} \
aws_secret_key=${SECRET_KEY} \
environment_tag=${ENVIRONMENT_TAG} \
db_master_password=${PASSWORD} \
environment_type=${ENVIRONMENT_TYPE}"
