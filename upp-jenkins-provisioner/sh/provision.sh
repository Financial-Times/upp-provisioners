#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

# base64 encode EC2 user data
/bin/base64 /cloudformation/userdata.sh | tr -d '\n' > /cloudformation/userdata.base64

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
instance_name=${INSTANCE_NAME} \
environment_type=${ENVIRONMENT_TYPE} \
aws_account=${AWS_ACCOUNT}"
