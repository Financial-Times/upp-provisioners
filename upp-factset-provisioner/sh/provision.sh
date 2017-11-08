#!/bin/bash

echo $VAULT_PASS > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
environment_name=${ENVIRONMENT_NAME} \
environment_tag=${ENVIRONMENT_TAG} \
system_code=${SYSTEM_CODE} \
db_master_password=${MASTER_PASSWORD} \
db_master_username=${MASTER_USERNAME} \
aws_account=${AWS_ACCOUNT}"
