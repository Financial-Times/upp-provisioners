#!/bin/bash

# Failover across region
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass failover.yml --extra-vars "\
cluster=${CLUSTER} \
environment_type=${ENVIRONMENT_TYPE} "
