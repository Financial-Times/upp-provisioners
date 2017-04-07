#!/bin/bash
set -e

# Create Ansible vault credentials
: "${VAULT_PASS:?Need to set VAULT_PASS non-empty}"
echo $VAULT_PASS > /data/vault.pass

: "${CLUSTER:?Need to set CLUSTER non-empty}"

ansible-playbook -vv decom.yml \
--vault-password-file=vault.pass \
--extra-vars "\
cluster=${CLUSTER}"
