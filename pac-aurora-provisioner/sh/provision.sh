#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass provision.yml --extra-vars "\
cluster=${CLUSTER} \
environment_type=${ENVIRONMENT_TYPE} "

# TO BE REPLACED BY CLOUDFORMATION

# Creation of cross region read replica
# Set AWS credentials
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="us-east-1"

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

# Create resources for the DB cluster in us-east-1
# DB parameter group, Cluster parameter group

aws rds create-db-parameter-group --db-parameter-group-name=pac-aurora-${CLUSTER}-dbgroup --db-parameter-group-family=aurora5.6 --description='PAC db parameter group'
aws rds create-db-cluster-parameter-group --db-cluster-parameter-group-name=pac-aurora-${CLUSTER}-clustergroup --db-parameter-group-family=aurora5.6 --description='PAC cluster parameter group'

# Create a DB cluster
aws rds create-db-cluster --db-cluster-identifier=pac-aurora-${CLUSTER}-useast --db-cluster-parameter-group-name=pac-aurora-${CLUSTER}-clustergroup --vpc-security-group-ids=sg-6b79a215 --db-subnet-group-name=pac-aurora-subnet-group --replication-source-identifier=${clusterARN} --engine=aurora

# Create two instances and register with the DB cluster
aws rds create-db-instance --db-cluster-identifier=pac-aurora-${CLUSTER}-useast --db-instance-class=db.t2.small --engine=aurora --db-instance-identifier=pac-aurora-${CLUSTER}-1 --db-parameter-group-name=pac-aurora-${CLUSTER}-dbgroup --no-publicly-accessible --db-subnet-group-name=pac-aurora-subnet-group
aws rds create-db-instance --db-cluster-identifier=pac-aurora-${CLUSTER}-useast --db-instance-class=db.t2.small --engine=aurora --db-instance-identifier=pac-aurora-${CLUSTER}-2 --db-parameter-group-name=pac-aurora-${CLUSTER}-dbgroup --no-publicly-accessible --db-subnet-group-name=pac-aurora-subnet-group
