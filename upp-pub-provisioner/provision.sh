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
  ami=$AMI \
  authors_bertha_url=${AUTHORS_BERTHA_URL} \
  aws_access_key_id=$AWS_ACCESS_KEY_ID \
  aws_image_monitor_test_uuid=$AWS_MONITOR_TEST_UUID \
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
  binary_s3_bucket=${BINARY_S3_BUCKET} \
  binary_writer_bucket=$BINARY_WRITER_BUCKET \
  branch_name=${BRANCH_NAME:=master} \
  carousel_bucket=${CAROUSEL_BUCKET} \
  carousel_enabled=${CAROUSEL_ENABLED} \
  clusterid=$CLUSTERID \
  coco_image_monitor_test_uuid=$COCO_MONITOR_TEST_UUID \
  concepts_rw_s3_bucket=$CONCEPTS_RW_S3_BUCKET \
  concepts_rw_s3_bucket_region=$CONCEPTS_RW_S3_BUCKET_REGION \
  concordances_dynamodb_table=${CONCORDANCES_DYNAMODB_TABLE} \
  concordances_topic_arn=${CONCORDANCES_TOPIC_ARN} \
  delivery_clusters_http_credentials=${DELIVERY_CLUSTERS_HTTP_CREDENTIALS}\
  delivery_clusters_urls=${DELIVERY_CLUSTERS_URLS} \
  environment_tag=${ENVIRONMENT_TAG:=default} \
  environment_type=${ENVIRONMENT_TYPE:=p} \
  dns_address=$DNS_ADDRESS \
  pam_api_key=${PAM_API_KEY}\
  pam_credential_validation_uuid=${PAM_CREDENTIAL_VALIDATION_UUID} \
  pam_maicm_validation_url=${PAM_MAICM_VALIDATION_URL} \
  pam_mam_validation_url=${PAM_MAM_VALIDATION_URL} \
  pam_mcpm_validation_url=${PAM_MCPM_VALIDATION_URL} \
  pam_mimm_validation_url=${PAM_MIMM_VALIDATION_URL} \
  pam_mlm_validation_url=${PAM_MLM_VALIDATION_URL} \
  pam_validator_credentials=${PAM_VALIDATOR_CREDENTIALS} \
  pam_video_validation_url=${PAM_VIDEO_VALIDATION_URL} \
  pam_wam_validation_url=${PAM_WAM_VALIDATION_URL} \
  region=$AWS_DEFAULT_REGION \
  roles_bertha_url=${ROLES_BERTHA_URL} \
  s3_image_bucket_urls=${S3_IMAGE_BUCKET_URLS} \
  services_definition_root_uri=${SERVICES_DEFINITION_ROOT_URI:=https://raw.githubusercontent.com/Financial-Times/pub-service-files/master/} \
  smartlogic_api_key=${SMARTLOGIC_API_KEY} \
  smartlogic_base_url=${SMARTLOGIC_BASE_URL} \
  smartlogic_model=${SMARTLOGIC_MODEL} \
  synthetic_article_payload=${SYNTHETIC_ARTICLE_PAYLOAD:=/com/ft/syntheticpublicationmonitor/templates/article-payload.json} \
  synthetic_article_uuid=${SYNTHETIC_ARTICLE_UUID} \
  synthetic_list_uuid=${SYNTHETIC_LIST_UUID} \
  tme_host=${TME_HOST:=tme.ft.com} \
  token=$TOKEN_URL \
  varnish_access_credentials=${CLUSTER_BASIC_HTTP_CREDENTIALS} \
  zones=$ZONES" \
  --vault-password-file=/vault.pass
