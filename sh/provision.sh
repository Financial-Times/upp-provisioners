#!/bin/bash
set -e

: "${VAULT_PASS:?Need to set VAULT_PASS non-empty}"
echo "Running playbook rdsserver.yml"

echo ${VAULT_PASS} > /data/vault.pass

: "${CLUSTER:?Need to set CLUSTER non-empty}"
: "${CLUSTER_SG:?Need to set CLUSTER_SG non-empty}"

ansible-playbook -vv rdsserver.yml \
--vault-password-file=vault.pass \
--extra-vars "\
cluster=${CLUSTER} \
environment_type=${ENVIRONMENT_TYPE} \
cluster_sg=${CLUSTER_SG}"
