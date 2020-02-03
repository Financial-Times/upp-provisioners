#!/bin/bash

# Create Ansible vault credentials
echo "$VAULT_PASS" > /ansible/vault.pass || exit

cd /ansible

ansible-playbook --vault-password-file=vault.pass decom.yml --tags "loader" --extra-vars "\
environment_name=${ENVIRONMENT_NAME} \
system_code=${SYSTEM_CODE} \
aws_account=${AWS_ACCOUNT} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} "
