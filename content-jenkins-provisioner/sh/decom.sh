#!/bin/bash

# Create Ansible vault credentials
echo $VAULT_PASS > /ansible/vault.pass

cd /ansible
ansible-playbook --vault-password-file=vault.pass decom.yml --extra-vars "\
aws_account=${AWS_ACCOUNT} \
instance_name=${INSTANCE_NAME} 
aws_access_key=${AWS_ACCESS_KEY} \
konstructor_api_key=${KONSTRUCTOR_API_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} "
