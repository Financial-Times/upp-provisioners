#!/bin/bash

# Create Ansible vault credentials
echo $VAULT_PASS > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass decom.yml --extra-vars "\
environment_name=${ENVIRONMENT_NAME} \
system_code=${SYSTEM_CODE} \
aws_account=${AWS_ACCOUNT}"
