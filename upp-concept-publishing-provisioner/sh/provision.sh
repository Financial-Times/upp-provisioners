#!/bin/bash

# Create Ansible vault credentials
echo $VAULT_PASS > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
cluster_name="upp-${CLUSTER_NAME}" \
aws_default_region=${AWS_DEFAULT_REGION} \
environment_tag=${ENVIRONMENT_TAG} \
ismultiregion=${IS_MULTI_REGION}"
