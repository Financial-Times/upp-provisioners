#!/bin/bash
# Retrieves the Cluster ARN for use in cross-region replication

# Set AWS credentials
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"

if [[ -z ${AWS_REGION} ]]; then
   AWS_REGION="eu-west-1"
fi

# Get the DBClusterIdentifier of the cluster we want to promote
for clusterName in $(aws rds describe-db-clusters --query 'DBClusters[].DBClusterIdentifier[]' --region=${AWS_REGION} --output text)
do
  if [[ $clusterName =~ ${CLUSTER} ]]; then
      dbClusterIdentifier=$clusterName
      break
  else
      continue
  fi
done

echo -n $dbClusterIdentifier

aws rds promote-read-replica-db-cluster --region ${AWS_REGION} --db-cluster-identifier ${dbClusterIdentifier}
