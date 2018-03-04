#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} \
cluster=${CLUSTER} \
pac_db_user_password=${PAC_DB_USER_PASSWORD} \
environment_type=${ENVIRONMENT_TYPE} \
source_snapshot=${SOURCE_SNAPSHOT} "