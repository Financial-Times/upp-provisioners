#!/bin/bash

# Place credentials to be able to run "aws" from shell for missing ansible commands, like adding tags to elb
echo "[Credentials]" >> /etc/boto.cfg
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> /etc/boto.cfg
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> /etc/boto.cfg
if [ -z "$AWS_MONITOR_TEST_UUID" ]; then AWS_MONITOR_TEST_UUID=$(uuidgen); fi
if [ -z "$COCO_MONITOR_TEST_UUID" ]; then COCO_MONITOR_TEST_UUID=$(uuidgen); fi

CLUSTERID=`echo $TOKEN_URL | sed "s/http.*\///g" | cut -c1-8`
AMI=`curl -s https://coreos.com/dist/aws/aws-stable.json | jq -r '.["eu-west-1"].hvm'`

. .venv/bin/activate && echo $VAULT_PASS > /vault.pass && ansible-playbook -i ~/.ansible_hosts /ansible/aws_coreos_site.yml --extra-vars " \
  clusterid=$CLUSTERID \
  ami=$AMI \
  token=$TOKEN_URL \
  services_definition_root_uri=${SERVICES_DEFINITION_ROOT_URI:=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/} \
  aws_access_key_id=$AWS_ACCESS_KEY_ID \ 
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
  binary_writer_bucket=$BINARY_WRITER_BUCKET \
  aws_image_monitor_test_uuid=$AWS_MONITOR_TEST_UUID \
  coco_image_monitor_test_uuid=$COCO_MONITOR_TEST_UUID \
  bridging_message_queue_proxy=${BRIDGING_MESSAGE_QUEUE_PROXY:=https://kafka-proxy-iw-uk-p-1.glb.ft.com,https://kafka-proxy-iw-uk-p-2.glb.ft.com} \
  varnish_access_credentials=${CLUSTER_BASIC_HTTP_CREDENTIALS} \
  environment_tag=${ENVIRONMENT_TAG:=default}" \
  --vault-password-file=/vault.pass

