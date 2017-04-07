#!/bin/bash

# Place credentials to be able to run "aws" from shell for missing ansible commands, like adding tags to elb
echo "[Credentials]" >> /etc/boto.cfg
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> /etc/boto.cfg
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> /etc/boto.cfg
if [ -z "$AWS_MONITOR_TEST_UUID"]; then AWS_MONITOR_TEST_UUID=$(uuidgen); fi
if [ -z "$COCO_MONITOR_TEST_UUID"]; then COCO_MONITOR_TEST_UUID=$(uuidgen); fi

CLUSTERID=`echo $TOKEN_URL | sed "s/http.*\///g" | cut -c1-8`

. .venv/bin/activate && echo $VAULT_PASS > /vault.pass && ansible-playbook -i ~/.ansible_hosts /ansible/print_userdata.yml --extra-vars " \
  clusterid=$CLUSTERID \
  token=$TOKEN_URL \
  services_definition_root_uri=${SERVICES_DEFINITION_ROOT_URI:=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/} \
  aws_access_key_id=$AWS_ACCESS_KEY_ID \ 
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
  binary_writer_bucket=$BINARY_WRITER_BUCKET \
  aws_image_monitor_test_uuid=$AWS_MONITOR_TEST_UUID \
  coco_image_monitor_test_uuid=$COCO_MONITOR_TEST_UUID \
  bridging_message_queue_proxy=${BRIDGING_MESSAGE_QUEUE_PROXY:=https://kafka-proxy-iw-uk-p-1.glb.ft.com,https://kafka-proxy-iw-uk-p-2.glb.ft.com} \
  brightcove_account_id=${BRIGHTCOVE_ACCOUNT_ID} \
  brightcove_auth='${BRIGHTCOVE_AUTH}' \
  environment_tag=${ENVIRONMENT_TAG:=default} \
  environment_type=${ENVIRONMENT_TYPE:=p} \
  tme_host=${TME_HOST:=default}" \
  --vault-password-file=/vault.pass

echo "Default:"
echo "--------"
cat default.template
echo "Persistent 1:"
echo "--------"
cat persistent1.template
echo "Persistent 2:"
echo "--------"
cat persistent2.template
echo "Persistent 3:"
echo "--------"
cat persistent3.template
