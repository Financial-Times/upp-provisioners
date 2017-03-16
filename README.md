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

## Provisioning a cluster
- Grab, customise and run the environment variables from the **AWS ElasticSearch - Provisioning Setup** LastPass note.
- The cluster name will be `${CF_TEMPLATE}-${DELIVERY_CLUSTER}` - eg, `upp-concepts-prod-uk`.
- If provisioning a cluster that has previously had a snapshot taken, and you wish to restore the latest ES snapshot, set `$RESTORE_ES_SNAPSHOT"` to `true`.
- Run the following Docker commands:
```
docker pull coco/aws-es-provisioner:latest
docker run \
    -e "CF_TEMPLATE=$CF_TEMPLATE" \
    -e "DELIVERY_CLUSTER=$DELIVERY_CLUSTER" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "RESTORE_ES_SNAPSHOT=$RESTORE_ES_SNAPSHOT" \
    coco/up-neo4j-cluster:latest /bin/bash provision.sh
```

## Decommisioning a cluster
- Export the required environment variables.
- The decommissioned cluster will be `${CF_TEMPLATE}-${DELIVERY_CLUSTER}` - eg, `upp-concepts-prod-uk`.
- If fully decommissioning a cluster, and you no longer need the CNAMEs or S3 bucket, set `$DELETE_CNAME` and `$DELETE_S3_BUCKET` to `true`.
- Run the following Docker command:
```
docker run \
    -e "CF_TEMPLATE=$CF_TEMPLATE" \
    -e "DELIVERY_CLUSTER=$DELIVERY_CLUSTER" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "DELETE_CNAME=$DELETE_CNAME" \
    -e "DELETE_S3_BUCKET=$DELETE_S3_BUCKET" \
    coco/up-neo4j-cluster:latest /bin/bash decom.sh
```
