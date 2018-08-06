#!/bin/bash

source $(dirname $0)/functions.sh || echo "Failed to source functions"

declare -a INSTANCES
STACKNAME=$(getStackName)

for each in $(aws ec2  --region $(getRegion) describe-instances --filters "Name=tag:aws:cloudformation:stack-name,Values=${STACKNAME}" --query 'Reservations[].Instances[].PrivateIpAddress' --output text); do
  INSTANCES+=( "$each" )
done

if [[ "${#INSTANCES[*]}" -eq "0" ]]; then #If number of records is 0 fail visibly
  errorAndExit "Failed to find any EC2 instances for stack named ${STACKNAME}" 1
else
  for each in ${INSTANCES[*]}; do
    INITIAL_HOSTS+="${each}:5000,"
  done
  echo "${INITIAL_HOSTS::-1}" #echo without trailing comma
fi
