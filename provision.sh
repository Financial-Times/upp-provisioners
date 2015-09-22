#!/bin/bash

# Place credentials to be able to run "aws" from shell for missing ansible commands, like adding tags to elb
echo "[Credentials]" >> /etc/boto.cfg
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> /etc/boto.cfg
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> /etc/boto.cfg

. .venv/bin/activate && echo $VAULT_PASS > /vault.pass && ansible-playbook -i ~/.ansible_hosts /ansible/aws_coreos_site.yml --extra-vars " \
  token=$TOKEN_URL \
  service_definition_location=${SERVICE_DEFINITION_LOCATION:=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/services.yaml} \
  aws_access_key_id=$AWS_ACCESS_KEY_ID \ 
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
  binary_writer_bucket=$BINARY_WRITER_BUCKET \
  aws_image_monitor_test_uuid=$AWS_MONITOR_TEST_UUID \
  ucs_image_monitor_test_uuid=$UCS_MONITOR_TEST_UUID \
  environment_tag=${ENVIRONMENT_TAG:=default}" \
  --vault-password-file=/vault.pass

