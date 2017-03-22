#!/bin/bash
set -x
set -e

: "${VAULT_PASS:?Need to set VAULT_PASS non-empty}"
echo "Running playbook rdsserver.yml"

echo ${VAULT_PASS} > /data/vault.pass

: "${CLUSTER:?Need to set CLUSTER non-empty}"

ansible-playbook -v rdsserver.yml \
--vault-password-file=vault.pass \
--extra-vars "\
cluster=${CLUSTER} \
environment_type=${ENVIRONMENT_TYPE}"
