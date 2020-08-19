#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

export AWS_REGION="eu-west-1"
export SUBNET_IDS="subnet-901020c8,subnet-5f00f438,subnet-8cbe4fc5"
export SECURITY_GROUPS="sg-39ef7b40,sg-f294008b"
export IMAGE_ID="ami-07d9160fa81ccffb5"
export VPC_ID="vpc-ee57bf89"
export DNS_STS_ASSUME_ROLE_ARN="arn:aws:iam::345152836601:role/route53-iam-dnsonlyroleuppprodE94AAA36-CAPB27QPX3K8"
export DNS_HOSTED_ZONE_ID="ZE8P6HDQA4Y9N"
export DNS_HOSTED_ZONE_NAME="upp.ft.com"
export CF_STACK_NAME="upp-staging-jumpbox"
export ENVIRONMENT_TYPE="t"
