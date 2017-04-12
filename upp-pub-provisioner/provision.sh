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
  services_definition_root_uri=${SERVICES_DEFINITION_ROOT_URI:=https://raw.githubusercontent.com/Financial-Times/pub-service-files/master/} \
  aws_access_key_id=$AWS_ACCESS_KEY_ID \ 
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \
  binary_writer_bucket=$BINARY_WRITER_BUCKET \
  concepts_rw_s3_bucket=$CONCEPTS_RW_S3_BUCKET \
  concepts_rw_s3_bucket_region=$CONCEPTS_RW_S3_BUCKET_REGION \
  aws_image_monitor_test_uuid=$AWS_MONITOR_TEST_UUID \
  coco_image_monitor_test_uuid=$COCO_MONITOR_TEST_UUID \
  bridging_message_queue_proxy=${BRIDGING_MESSAGE_QUEUE_PROXY:=https://kafka-proxy-iw-uk-p-1.glb.ft.com,https://kafka-proxy-iw-uk-p-2.glb.ft.com} \
  varnish_access_credentials=${CLUSTER_BASIC_HTTP_CREDENTIALS} \
  authors_bertha_url=${AUTHORS_BERTHA_URL} \
  roles_bertha_url=${ROLES_BERTHA_URL} \	  	  
  brands_bertha_url=${BRANDS_BERTHA_URL} \	  	  
  mappings_bertha_url=${MAPPINGS_BERTHA_URL} \
  environment_tag=${ENVIRONMENT_TAG:=default} \
  environment_type=${ENVIRONMENT_TYPE:=p} \
  tme_host=${TME_HOST:=tme.ft.com} \
  brightcove_account_id=${BRIGHTCOVE_ACCOUNT_ID} \
  brightcove_auth='${BRIGHTCOVE_AUTH}' \
  delivery_clusters_urls=${DELIVERY_CLUSTERS_URLS} \
  s3_image_bucket_urls=${S3_IMAGE_BUCKET_URLS} \
  delivery_clusters_http_credentials=${DELIVERY_CLUSTERS_HTTP_CREDENTIALS}\
  binary_s3_bucket=${BINARY_S3_BUCKET} \
  pam_mat_validation_url=${PAM_MAT_VALIDATION_URL} \
  pam_mcpm_validation_url=${PAM_MCPM_VALIDATION_URL} \
  pam_mat_validation_credentials=${PAM_MAT_VALIDATION_CREDENTIALS} \
  pam_credential_validation_uuid=${PAM_CREDENTIAL_VALIDATION_UUID} \
  synthetic_article_uuid=${SYNTHETIC_ARTICLE_UUID} \
  synthetic_article_payload=${SYNTHETIC_ARTICLE_PAYLOAD:=/com/ft/syntheticpublicationmonitor/templates/article-payload.json} \
  synthetic_list_uuid=${SYNTHETIC_LIST_UUID}" \
  --vault-password-file=/vault.pass
