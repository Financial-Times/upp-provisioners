#!/bin/bash

cd /ansible

ansible-playbook update.yml --extra-vars "\
kon_dns_apikey=${KON_DNS_APIKEY} \
environment_type=${ENVIRONMENT_TYPE} \
aws_region=${AWS_REGION} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} "
