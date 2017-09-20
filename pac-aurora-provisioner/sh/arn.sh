#!/bin/bash
# Retrieves the Cluster ARN for use in cross-region replication

# Set AWS credentials
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"

AWS_REGION=${1}
if [[ -z ${AWS_REGION} ]]; then
   AWS_REGION="eu-west-1"
fi

# TODO: Abstract out the AWS Region so we can re-use this script for failover.

# Get the ARN of the source cluster from eu-west-1
for clusterName in $(aws rds describe-db-clusters --query 'DBClusters[].DBClusterArn[]' --region=${AWS_REGION} --output text)
do
  if [[ $clusterName =~ ${CLUSTER} ]]; then
      clusterARN=$clusterName
      break
  else
      continue
  fi
done

echo -e $clusterARN
