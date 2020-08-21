#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'


RESOURCES_PREFIX="upp"
AWS_REGION="eu-west-1"
VPC_ID="vpc-ee57bf89"

ENVIRONMENT_TAG="t"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"

JENKINS_CONTROLLER_INSTANCE_TYPE="t3.medium"
JENKINS_CONTROLLER_SUBNET_ID="subnet-901020c8"
JENKINS_CONTROLLER_KEYPAIR_NAME="ft-tech-content-platform-prod"
JENKINS_CONTROLLER_IMAGE_ID="ami-01ab3f5dc3175149d"
JENKINS_CONTROLLER_EBS_ID="vol-02fd9b4570ee4f688"
JENKINS_CONTROLLER_AZ="eu-west-1a"
JENKINS_CONTROLLER_JAVA_OPTIONS="-Djava.awt.headless=true -Dpermissive-script-security.enabled=true"
JENKINS_PACKER_RPM_VERSION="jenkins-2.150.1-1.1"

STACK_SECURITY_GROUP_IDS="sg-f294008b, sg-39ef7b40"
JENKINS_ALB_SUBNETS="subnet-901020c8, subnet-5f00f438"
JENKINS_ALB_LISTENER_CERTIFICATE_ARN="arn:aws:acm:eu-west-1:469211898354:certificate/c9fc4ada-63ee-4951-b1ea-429ba586cbf7"

DNS_HOSTED_ZONE_NAME="upp.ft.com"
DNS_HOSTED_ZONE_ID="ZE8P6HDQA4Y9N"
DNS_STS_ASSUME_ROLE_ARN="arn:aws:iam::345152836601:role/route53-iam-dnsonlyroleuppprodE94AAA36-CAPB27QPX3K8"

CF_STACK_NAME="${RESOURCES_PREFIX}-jenkins-${JENKINS_UID}"
