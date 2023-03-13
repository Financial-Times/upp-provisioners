#!/bin/bash

# Validate that ${CF_TEMPLATE}.yml exists
if [ ! -f /cloudformation/${CF_TEMPLATE}.yml ]; then
  echo -e "Error - ${CF_TEMPLATE}.yml doesn't exist.\n"
  echo -e "Valid \$CF_TEMPLATE values are:"
  ls /cloudformation/ | sed 's/.yml//g'
  echo
  exit 1
fi

env_vars="/vars/${CF_TEMPLATE}-${DELIVERY_CLUSTER}.yml"
# Check if there are custom provision properties
if [ ! -f ${env_vars} ]; then
  echo -e "Warning - ${env_vars} doesn't exist.\n"
  echo -e "Using /vars/defaults.yml values."
  env_vars="/vars/defaults.yml"
fi

# Create Ansible vault credentials
echo ${VAULT_PASS} >/ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
cf_template=${CF_TEMPLATE} \
delivery_cluster=${DELIVERY_CLUSTER} \
aws_default_region=${AWS_DEFAULT_REGION} \
environment_type=${ENVIRONMENT_TYPE} \
restore_es_snapshot=${RESTORE_ES_SNAPSHOT} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} \
aws_account=${AWS_ACCOUNT} \
env_vars=${env_vars}
"
