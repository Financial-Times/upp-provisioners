#!/bin/bash

# Validate that ${CF_TEMPLATE}.yml exists
if [ ! -f /cloudformation/${CF_TEMPLATE}.yml ] ; then
    echo -e "Error - ${CF_TEMPLATE}.yml doesn't exist.\n"
    echo -e "Valid \$CF_TEMPLATE values are:"
    ls /cloudformation/ | sed 's/.yml//g'
    echo
    exit 1
fi

# Create Ansible vault credentials
echo $VAULT_PASS > /ansible/vault.pass

cd /ansible
ansible-playbook --vault-password-file=vault.pass decom.yml --extra-vars "\
cf_template=${CF_TEMPLATE} \
delivery_cluster=${DELIVERY_CLUSTER} \
aws_default_region=${AWS_DEFAULT_REGION} \
environment_type=${ENVIRONMENT_TYPE} \
delete_s3_bucket=${DELETE_S3_BUCKET} \
aws_account=${AWS_ACCOUNT}"
