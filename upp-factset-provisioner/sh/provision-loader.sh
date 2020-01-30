#!/bin/bash

echo "$VAULT_PASS" > /ansible/vault.pass

cd /ansible || exit

ansible-playbook --vault-password-file=vault.pass provision.yml --tags "loader" --extra-vars "\
environment_name=${ENVIRONMENT_NAME} \
environment_tag=${ENVIRONMENT_TAG} \
LoaderSecurityGroupId=${LOADER_SECURITY_GROUP_ID} \
FTResourcesSecurityGroupId=${FT_RESOURCES_SECURITY_GROUP_ID} \
aws_account=${AWS_ACCOUNT} \
aws_access_key=${AWS_ACCESS_KEY} \
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} "
