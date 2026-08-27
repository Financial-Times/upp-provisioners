#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

export AWS_REGION="eu-west-1"
export SUBNET_IDS="subnet-024e2e32aefaa01c5,subnet-02526d7213a359f48,subnet-0f2c8a8f1e3db176a"
#export SECURITY_GROUPS="sg-39ef7b40,sg-f294008b"
export EnvironmentType="t"
export EnvironmentName='staging'
export IMAGE_ID="ami-0069d66985b09d219"
export DNS_HOSTED_ZONE_NAME="upp.ft.com"
export DNS_HOSTED_ZONE_ID="ZE8P6HDQA4Y9N"
export VpcID="vpc-ee57bf89"
export CF_STACK_NAME="upp-staging-rosette-rts"
export DNS_STS_ASSUME_ROLE_ARN="arn:aws:iam::345152836601:role/route53-iam-dnsonlyroleuppprodE94AAA36-CAPB27QPX3K8"
