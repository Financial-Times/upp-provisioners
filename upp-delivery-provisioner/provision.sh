#!/bin/bash

# Place credentials to be able to run "aws" from shell for missing ansible commands, like adding tags to elb
echo "[Credentials]" >> /etc/boto.cfg
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> /etc/boto.cfg
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> /etc/boto.cfg
if [ -z "$AWS_MONITOR_TEST_UUID" ]; then AWS_MONITOR_TEST_UUID=$(uuidgen); fi
if [ -z "$COCO_MONITOR_TEST_UUID" ]; then COCO_MONITOR_TEST_UUID=$(uuidgen); fi

. .venv/bin/activate

CLUSTERID=`echo $TOKEN_URL | sed "s/http.*\///g" | cut -c1-8`
AMI=`curl -s https://coreos.com/dist/aws/aws-stable.json | jq --arg region $AWS_DEFAULT_REGION -r '.[$region].hvm'`
ZONES=(`aws ec2 describe-availability-zones --region $AWS_DEFAULT_REGION | jq -r '.AvailabilityZones[].ZoneName'`)

echo $VAULT_PASS > /vault.pass && ansible-playbook -i ~/.ansible_hosts /ansible/aws_coreos_site.yml --extra-vars " \
  clusterid=$CLUSTERID \
  ami=$AMI \
  zones=$ZONES \
  region=$AWS_DEFAULT_REGION \
  token=$TOKEN_URL \
  services_definition_root_uri=${SERVICES_DEFINITION_ROOT_URI:=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/} \
  aws_access_key_id=$AWS_ACCESS_KEY_ID \
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
  binary_writer_bucket=$BINARY_WRITER_BUCKET \
  generic_rw_bucket=$GENERIC_RW_BUCKET \
  aws_image_monitor_test_uuid=$AWS_MONITOR_TEST_UUID \
  coco_image_monitor_test_uuid=$COCO_MONITOR_TEST_UUID \
  bridging_message_queue_proxy=${BRIDGING_MESSAGE_QUEUE_PROXY:=https://kafka-proxy-iw-uk-p-1.glb.ft.com,https://kafka-proxy-iw-uk-p-2.glb.ft.com} \
  varnish_access_credentials=${CLUSTER_BASIC_HTTP_CREDENTIALS} \
  api_host=${API_HOST:=api.ft.com} \
  upp_gateway_host=$UPP_GATEWAY_HOST \
  upp_gateway_port=${UPP_GATEWAY_PORT:=443} \
  neo4j_read_url=$NEO4J_READ_URL \
  neo4j_write_url=$NEO4J_WRITE_URL \
  ces_host=$CES_HOST \
  ces_credentials=$CES_CREDENTIALS \
  environment_tag=${ENVIRONMENT_TAG:=default} \
  environment_type=${ENVIRONMENT_TYPE:=p} \
  aws_es_endpoint=${AWS_ES_ENDPOINT} \
  aws_es_content_endpoint=${AWS_ES_CONTENT_ENDPOINT} \
  methode_api=${METHODE_API} \
  neo4j_fleet_endpoint=${NEO4J_FLEET_ENDPOINT} \
  branch_name=${BRANCH_NAME:=master}" \
  --vault-password-file=/vault.pass
