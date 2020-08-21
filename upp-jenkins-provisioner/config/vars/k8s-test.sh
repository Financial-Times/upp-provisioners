#!/usr/bin/env bash
# shellcheck disable=SC2034

set -euo pipefail
IFS=$'\n\t'

RESOURCES_PREFIX="upp"
AWS_REGION="eu-west-1"
VPC_ID="vpc-f75fb790"

ENVIRONMENT_TAG="d"
SYSTEM_CODE_TAG="upp"
TEAM_DL_TAG="universal.publishing.platform@ft.com"

JENKINS_CONTROLLER_INSTANCE_TYPE="t2.xlarge"
JENKINS_CONTROLLER_SUBNET_ID="subnet-2a1de94d"
JENKINS_CONTROLLER_KEYPAIR_NAME="ft-tech-content-platform-test"
JENKINS_CONTROLLER_IMAGE_ID="ami-0dff567761710b3c6"
JENKINS_CONTROLLER_EBS_ID="vol-0ed84015eb42cefd9" # this is a temp volume
JENKINS_CONTROLLER_AZ="eu-west-1a"
JENKINS_CONTROLLER_JAVA_OPTIONS="-Djava.awt.headless=true -Dpermissive-script-security.enabled=true -Xmx5120m"
JENKINS_PACKER_RPM_VERSION="jenkins-2.190.1-1.1"

STACK_SECURITY_GROUP_IDS="sg-f7c85c8e, sg-8bcb5ff2"
JENKINS_ALB_SUBNETS="subnet-2a1de94d, subnet-c1b94888"
JENKINS_ALB_LISTENER_CERTIFICATE_ARN="arn:aws:acm:eu-west-1:070529446553:certificate/a6ab3d87-cdae-4db4-838f-3dbce570ad47"

DNS_HOSTED_ZONE_NAME="upp.ft.com"
DNS_HOSTED_ZONE_ID="ZE8P6HDQA4Y9N"
DNS_STS_ASSUME_ROLE_ARN="arn:aws:iam::345152836601:role/route53-iam-dnsonlyroleuppprodE94AAA36-CAPB27QPX3K8"

CF_STACK_NAME="${RESOURCES_PREFIX}-jenkins-${JENKINS_UID}"
