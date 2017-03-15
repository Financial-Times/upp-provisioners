# AWS ElasticSearch Service provisioner

The AWS ES provisioning process will:

 * Create an ElasticSearch Service using the specified CloudFormation template
 * Ensure an S3 bucket exists, and register it to the ES cluster
 * Restore the most recent backup in the S3 bucket, if one exists
 * Create or update appropriate CNAME records for the cluster

The decommisioning process will:

 * Take a backup of the cluster
 * Delete the cluster
 * Optionally delete the S3 bucket and DNS records (for full decommissioning)

## Build
The AWS ES provisioner is built as a Docker image:
`docker build -t coco/aws-es-provisioner:latest .`

## Provisioning a new cluster
- Grab, customise and run the environment variables from the *AWS ElasticSearch - Provisioning Setup* LastPass note.
- Run the following Docker commands:
```
docker pull coco/aws-es-provisioner:latest
docker run \
    -e "CLUSTER_NAME=$CLUSTER_NAME" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "CF_TEMPLATE=$CF_TEMPLATE" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    coco/up-neo4j-cluster:latest /bin/bash provision.sh
```

## Decommisioning a cluster
- Export the required environment variables.
- Run the following Docker command:
```
docker run \
    -e "CLUSTER_NAME=$CLUSTER_NAME" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "VAULT_PASS=$VAULT_PASS" \
    coco/up-neo4j-cluster:latest /bin/bash decom.sh
```
