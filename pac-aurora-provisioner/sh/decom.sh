#!/bin/bash

# Create Ansible vault credentials
echo ${VAULT_PASS} > /ansible/vault.pass

cd /ansible

ansible-playbook --vault-password-file=vault.pass decom.yml --extra-vars "\
cluster=${CLUSTER} \
environment_type=${ENVIRONMENT_TYPE} "

# TO BE REPLACED BY CLOUDFORMATION

# Delete the cross region read replica
# Set AWS credentials
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="us-east-1"

# Delete the db instances in the cluster and wait till the deletion operation finishes
for i in {1..2};
do
    aws rds delete-db-instance --db-instance-identifie=pac-aurora-${CLUSTER}-$i
    aws rds wait db-instance-deleted --db-instance-identifie=pac-aurora-${CLUSTER}-$i
done

# Delete the DB cluster
aws rds delete-db-cluster --db-cluster-identifier=pac-aurora-${CLUSTER}-useast --skip-final-snapshot

# Delete the DB instance and cluster parameter group
aws rds delete-db-parameter-group --db-parameter-group-name=pac-aurora-${CLUSTER}-dbgroup
aws rds delete-db-cluster-parameter-group --db-cluster-parameter-group-name=pac-aurora-${CLUSTER}-clustergroup