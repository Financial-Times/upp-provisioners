#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass failover.yml --extra-vars "\
cluster=${CLUSTER} \
failover_to_region=${FAILOVER_TO_REGION} \
failover_from_region=${FAILOVER_FROM_REGION} \
environment_type=${ENVIRONMENT_TYPE} "
