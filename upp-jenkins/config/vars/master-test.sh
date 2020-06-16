#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

STACK_RESOURCES_PREFIX="upp"
AWS_REGION="eu-west-1"
ENVIRONMENT_TAG="d"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"
JENKINS_MASTER_INSTANCE_TYPE="c5.xlarge"
STACK_VPC_ID="vpc-f75fb790"
JENKINS_MASTER_SUBNET_ID="subnet-2a1de94d"
JENKINS_MASTER_KEYPAIR_NAME="bboykov-keypair-ft-tech-content-platform-test"
JENKINS_MASTER_IMAGE_ID="ami-0effb3bf1d62e6501"
JENKINS_MASTER_AZ="eu-west-1a"
JENKINS_MASTER_JAVA_OPTIONS="-Djava.awt.headless=true -Dpermissive-script-security.enabled=true -Xmx3072m"
STACK_SECURITY_GROUP_IDS="sg-f7c85c8e, sg-8bcb5ff2"
JENKINS_MASTER_EBS_ID="vol-083d785436e38888a"
ALB_LISTENER_CERTIFICATE_ARN="arn:aws:acm:eu-west-1:070529446553:certificate/a6ab3d87-cdae-4db4-838f-3dbce570ad47"
JENKINS_ALB_SUBNETS="subnet-2a1de94d, subnet-c1b94888"
DNS_HOSTED_ZONE_NAME="upp.ft.com"
DNS_HOSTED_ZONE_ID="ZE8P6HDQA4Y9N"
# DNS_HOSTED_ZONE_NAME="testupp.ft.com" # Test zone
# DNS_HOSTED_ZONE_ID="Z2EI1H5MEKCZ4R" # Test zone
DNS_STS_ASSUME_ROLE_ARN="arn:aws:iam::345152836601:role/route53-iam-dnsonlyroleuppprodE94AAA36-CAPB27QPX3K8"
CF_STACK_NAME="${STACK_RESOURCES_PREFIX}-jenkins-${JENKINS_UID}"
