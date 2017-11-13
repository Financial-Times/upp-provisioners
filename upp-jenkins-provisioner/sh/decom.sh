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
instance_name=${INSTANCE_NAME} \
aws_account=${AWS_ACCOUNT}"
