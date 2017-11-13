#!/bin/bash

# Create Ansible vault credentials
echo $VAULT_PASS > /ansible/vault.pass

cd /ansible
ansible-playbook --vault-password-file=vault.pass decom.yml --extra-vars "\
aws_account=${AWS_ACCOUNT} \
instance_name=${INSTANCE_NAME} "
