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
  aggregate_concept_bucket=${AGGREGATE_CONCEPT_BUCKET} \
  aggregate_concept_queue=${AGGREGATE_CONCEPT_QUEUE} \
  ami=$AMI \
  api_host=${API_HOST:=api.ft.com} \
  aws_access_key_id=$AWS_ACCESS_KEY_ID \
  aws_es_content_endpoint=${AWS_ES_CONTENT_ENDPOINT} \
  aws_es_endpoint=${AWS_ES_ENDPOINT} \
  aws_image_monitor_test_uuid=$AWS_MONITOR_TEST_UUID \
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
  binary_writer_bucket=$BINARY_WRITER_BUCKET \
  branch_name=${BRANCH_NAME:=master} \
  ces_credentials=$CES_CREDENTIALS \
  ces_host=$CES_HOST \
  clusterid=$CLUSTERID \
  coco_image_monitor_test_uuid=$COCO_MONITOR_TEST_UUID \
  content_retrieval_throttle=$CONTENT_RETRIEVAL_THROTTLE \
  dynamodb_table=${DYNAMODB_TABLE} \
  environment_tag=${ENVIRONMENT_TAG:=default} \
  environment_type=${ENVIRONMENT_TYPE:=p} \
  kinesis_stream_name=${KINESIS_STREAM_NAME} \
  methode_api=${METHODE_API} \
  neo4j_fleet_endpoint=${NEO4J_FLEET_ENDPOINT} \
  neo4j_read_url=$NEO4J_READ_URL \
  neo4j_write_url=$NEO4J_WRITE_URL \
  region=$AWS_DEFAULT_REGION \
  services_definition_root_uri=${SERVICES_DEFINITION_ROOT_URI:=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/} \
  token=$TOKEN_URL \
  upp_exports_content_bucket_name=$EXPORTS_BUCKET_NAME \
  upp_exports_content_bucket_prefix=$BUCKET_CONTENT_PREFIX \
  upp_exports_concepts_bucket_prefix=$BUCKET_CONCEPT_PREFIX \
  upp_gateway_host=$UPP_GATEWAY_HOST \
  upp_gateway_port=${UPP_GATEWAY_PORT:=443} \
  varnish_access_credentials=${CLUSTER_BASIC_HTTP_CREDENTIALS} \
  zones=$ZONES" \
  --vault-password-file=/vault.pass
