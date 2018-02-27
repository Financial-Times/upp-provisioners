#!/bin/bash

# Create Ansible vault credentials
echo $VAULT_PASS > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
environment_tag=${ENVIRONMENT_TAG} \
environment_type=${ENVIRONMENT_TYPE} \
aws_account=${AWS_ACCOUNT}"
