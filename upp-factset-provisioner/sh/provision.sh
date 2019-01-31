#!/bin/bash

echo $VAULT_PASS > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
environment_name=${ENVIRONMENT_NAME} \
environment_tag=${ENVIRONMENT_TAG} \
db_master_password=${MASTER_PASSWORD} \
aws_account=${AWS_ACCOUNT} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} "
