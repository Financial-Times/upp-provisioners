#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible
ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
cf_template=${CF_TEMPLATE} \
delivery_cluster=${DELIVERY_CLUSTER} \
aws_default_region=${AWS_DEFAULT_REGION} \
environment_type=${ENVIRONMENT_TYPE}"
