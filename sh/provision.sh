#!/bin/bash
set -x
set -e

echo "Running playbook rdsserver.yml"

echo ${VAULT_PASS} > /data/vault.pass

ansible-playbook -v rdsserver.yml \
--vault-password-file=vault.pass \
--extra-vars "\
cluster=${CLUSTER} \
environment_type=${ENVIRONMENT_TYPE}"
