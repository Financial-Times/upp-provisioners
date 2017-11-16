# AWS ElasticSearch Service provisioner

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

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
- The full cluster name will be `${CF_TEMPLATE}-${DELIVERY_CLUSTER}` - eg, `upp-concepts-prod-uk`.
- The full cluster name has a maxmimum length of 28 characters.
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
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
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
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    coco/upp-elasticsearch-provisioner:latest /bin/bash decom.sh
```

- Note that the `Delete ElasticSearch cluster` step may take up to 15 minutes, as CloudFormation waits until the ElasticSearch cluster is fully decommissioned before returning a success code.
- You can check the progress of the CF stack deletion in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).

## Migrating data between ElasticSearch clusters

Note that the following instructions assume that the source and target clusters have been created using `upp-elasticsearch-provisioner`, which will automatically create and register an S3 bucket for manual snapshots.

If your ES cluster has not been created by the provisioner, you will need to create and register an S3 bucket yourself - speak to your friendly neighbourhood Integration Engineer for help.

For the following steps, using [Postman](https://www.getpostman.com/) (or a similar tool) is strongly recommended, as it means you don't have to mess about with AWS credentials and certificates.

You will need to pass the `content-containers-apps` credentials to Postman, which are available in LastPass.

![](https://i.imgur.com/EYXPYCB.png)

### Take a snapshot of the source ElasticSearch cluster

- On your source cluster, send a `PUT` request to the following URL to create a snapshot, replacing your cluster hostname and snapshot name with appropriate values:
```
https://search-upp-concepts-source-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/20170526-efinlay
```

- Depending on the size of the source cluster, this may take some time to complete. You can check the progress of the snapshot by sending a `GET` request to the following URL:
```
https://search-upp-concepts-source-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/_all
```

### Copy snapshot data to target ElasticSearch cluster

Run the following commands on an AWS EC2 instance in the same region as your S3 bucket. You can run the commands locally, but it will be slower to sync the data to and from the buckets.

You will need to have `awscli` installed, and have configured credentials with appropriate IAM permissions to perform S3 actions. 

If you are copying data between different AWS accounts, you will need credentials for each account.

Note that you will also need sufficient disk space to temporarily store your snapshot data.

- Run the following command to list the snapshot size:

```
aws s3 ls --summarize --human-readable --recursive s3://upp-concepts-source-cluster-backup/ --profile content-prod
```

- Sync the S3 bucket to your EC2 instance - make sure you do this in an empty directory:

```
aws s3 sync s3://upp-concepts-source-cluster-backup/ . --profile content-prod
```

- Sync the data on your EC2 instance to the target S3 bucket:

```
aws s3 sync . s3://upp-concepts-target-cluster-backup/ --profile content-test
```

- Optional - remove the copy of the data on your EC2 instance and the source S3 bucket.

### Restore snapshot to target ElasticSearch cluster

- Send a `GET` request to check the snapshot is visible in your target cluster:
```
https://search-upp-concepts-target-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/_all
```

- Trigger a restore of the snapshot in the target cluster. Send a `POST` request to the following URL:
```
https://search-upp-concepts-target-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/20170526-efinlay/_restore
```

- To check the progress of the restore, send a `GET` request to the following URL:
```
https://search-upp-concepts-target-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/efinlay-20170615/_status
```

- Once complete, the cluster health will change from 'yellow' to 'green' - you can check by sending a `GET` request to:

```
https://search-upp-concepts-target-cluster.eu-west-1.es.amazonaws.com/_cluster/health
```

- All done! You can delete the snapshot files from the target cluster's S3 bucket, unless you want to keep the snapshot for future use.
