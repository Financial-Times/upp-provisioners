#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass decom.yml --extra-vars "\
cluster=${CLUSTER} "