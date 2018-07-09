#!/bin/bash

#echo $VAULT_PASS > /ansible/vault.pass
#--vault-password-file=vault.pass

cd /ansible

ansible-playbook provision.yml --extra-vars "\
environment_type=${ENVIRONMENT_TYPE} \
aws_region=${AWS_REGION} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} "
