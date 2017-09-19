#!/bin/bash
# Retrieves the Cluster ARN for use in cross-region replication

# Set AWS credentials
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"

# Get the ARN of the source cluster from eu-west-1
for clusterName in $(aws rds describe-db-clusters --query 'DBClusters[].DBClusterArn[]' --region=eu-west-1 --output text)
do
  if [[ $clusterName =~ ${CLUSTER} ]]; then
      clusterARN=$clusterName
      break
  else
      continue
  fi
done

echo -e $clusterARN
