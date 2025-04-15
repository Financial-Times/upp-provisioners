#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

export AWS_REGION="eu-west-1"
export SUBNET_IDS="subnet-024e2e32aefaa01c5"
export EnvironmentType="t"
export EnvironmentName='staging'
export IMAGE_ID="ami-0069d66985b09d219"
export VpcID="vpc-ee57bf89"
export CF_STACK_NAME="upp-staging-rosette-tcat"
