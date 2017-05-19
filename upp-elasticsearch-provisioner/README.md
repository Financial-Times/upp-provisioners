# AWS ElasticSearch Service provisioner

The AWS ES provisioning process will:

 * Create an ElasticSearch Service using the specified CloudFormation template
 * Ensure an S3 bucket exists, and register it to the ES cluster
 * Create or update an appropriate CNAME record for the cluster
 * (Optionally) restore the most recent snapshot in the S3 bucket

The decommissioning process will:

 * Take a snapshot of the cluster
 * Delete the cluster
 * Delete the cluster CNAME record
 * (Optionally) delete the S3 bucket for full decommissioning

## Building the Docker image
The AWS ES provisioner can be built locally as a Docker image:

`docker build -t coco/upp-elasticsearch-provisioner:local .`

Automated DockerHub builds are also triggered on new releases, located [here](https://hub.docker.com/r/coco/upp-elasticsearch-provisioner/).

## Provisioning a cluster
- Grab, customize and export the environment variables from the **AWS ElasticSearch - Provisioning Setup** LastPass note.
- The cluster name will be `${CF_TEMPLATE}-${DELIVERY_CLUSTER}` - eg, `upp-concepts-prod-uk`.
- The cluster name length must be less than or equal to 28
- If provisioning a cluster that has previously had a snapshot taken, and you wish to restore the latest ES snapshot, set `$RESTORE_ES_SNAPSHOT"` to `true`.
- Run the following Docker commands:
```
docker pull coco/upp-elasticsearch-provisioner:latest
docker run \
    -e "CF_TEMPLATE=$CF_TEMPLATE" \
    -e "DELIVERY_CLUSTER=$DELIVERY_CLUSTER" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "RESTORE_ES_SNAPSHOT=$RESTORE_ES_SNAPSHOT" \
    coco/upp-elasticsearch-provisioner:latest /bin/bash provision.sh
```

- Note that the `Create ElasticSearch cluster` step may take up to 15 minutes, as CloudFormation waits until the ElasticSearch cluster is fully provisioned and online before returning a success code.
- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).

## Decommissioning a cluster
- Grab, customize and export the environment variables from the **AWS ElasticSearch - Provisioning Setup** LastPass note.
- The decommissioned cluster will be `${CF_TEMPLATE}-${DELIVERY_CLUSTER}` - eg, `upp-concepts-prod-uk`.
- If fully decommissioning a cluster, and you no longer need the S3 bucket or the ES snapshots inside, set `$DELETE_S3_BUCKET` to `true`.
- Run the following Docker command:
```
docker pull coco/upp-elasticsearch-provisioner:latest
docker run \
    -e "CF_TEMPLATE=$CF_TEMPLATE" \
    -e "DELIVERY_CLUSTER=$DELIVERY_CLUSTER" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "DELETE_S3_BUCKET=$DELETE_S3_BUCKET" \
    coco/upp-elasticsearch-provisioner:latest /bin/bash decom.sh
```

- Note that the `Delete ElasticSearch cluster` step may take up to 15 minutes, as CloudFormation waits until the ElasticSearch cluster is fully decommissioned before returning a success code.
- You can check the progress of the CF stack deletion in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).
