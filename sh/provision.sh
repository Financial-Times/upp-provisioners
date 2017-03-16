#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible
ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
cluster_name=${CLUSTER_NAME} \
aws_default_region=${AWS_DEFAULT_REGION} \
cf_template=${CF_TEMPLATE} \
environment_type=${ENVIRONMENT_TYPE}"
