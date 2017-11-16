#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
aws_account=${AWS_ACCOUNT} \
environment_type=${ENVIRONMENT_TYPE} \
instance_name=${INSTANCE_NAME} "