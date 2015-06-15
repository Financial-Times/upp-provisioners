#!/bin/bash

if [ ! -z "$AWS_ACCESS_KEY_ID" ] && [ ! -z "$AWS_SECRET_ACCESS_KEY" ]; then
    . .venv/bin/activate && echo $VAULT_PASS > /vault.pass && ansible-playbook -i ~/.ansible_hosts aws_coreos_site.yml --extra-vars "token=$TOKEN_URL deployer_service_file_location=$DEPLOYER_SERVICE_FILE_LOCATION aws_access_key_id=$AWS_ACCESS_KEY_ID aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" --vault-password-file=/vault.pass 
else
    . .venv/bin/activate && echo $VAULT_PASS > /vault.pass && ansible-playbook -i ~/.ansible_hosts aws_coreos_site.yml --extra-vars "token=$TOKEN_URL deployer_service_file_location=$DEPLOYER_SERVICE_FILE_LOCATION" --vault-password-file=/vault.pass 
fi
