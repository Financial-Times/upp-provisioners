#!/bin/bash

# Create Ansible vault credentials
echo $VAULT_PASS > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass decom.yml --extra-vars "\
environment_tag=${ENVIRONMENT_TAG} \
aws_default_region=${AWS_DEFAULT_REGION} \
is_multi_region=${IS_MULTI_REGION} \
aws_secondary_region=${AWS_SECONDARY_REGION}"