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

## Migrating data between ElasticSearch clusters
- Create your target cluster using the standard provisioning process.

- Run `register-es-snapshot-dir.py`, authorizing your source cluster to create a backup in the target cluster's S3 bucket. Note that you will need to replace some parameters, as detailed below.

    - Replace the `access_key` and `secret_key` values with the `upp-elasticsearch-provisioner` user keys for the appropriate AWS account. These are listed in LastPass.

    - Replace the `role` value with the the appropriate role ARN:
```
ft-tech-content-platform-test:
arn:aws:iam::070529446553:role/upp-elasticsearch-backup-role
ft-tech-content-platform-prod:
arn:aws:iam::469211898354:role/upp-elasticsearch-backup-role
```

- An example command is shown below:
```
python register-es-snapshot-dir.py \
--region eu-west-1 \
--endpoint search-upp-concepts-source-cluster.eu-west-1.es.amazonaws.com \
--access_key example-access-key \
--secret_key example-secret-key \
--bucket upp-concepts-target-cluster-backup
--role arn:aws:iam::070529446553:role/upp-elasticsearch-backup-role
```

- For the following steps, using Postman is much easier than `curl`, as you need to pass the AWS credentials, and Postman allows you to do this with a nice GUI. :)

- On your source cluster, send a `PUT` request to the following URL to create a snapshot, replacing your cluster hostname and snapshot name with appropriate values:
```
https://search-upp-concepts-source-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/snapshot-20170526
```

- Depending on the size of the source cluster, this may take up to 15 minutes to complete. You can check the progress of the snapshot by sending a `GET` request to the following URL:
```
https://search-upp-concepts-source-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/_all
```

- Once the backup is complete, send a `GET` request to check the snapshot is visible in your target cluster:
```
https://search-upp-concepts-target-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/_all
```

- Trigger a restore of the snapshot in the target cluster. Send a `POST` request to the following URL:
```
https://search-upp-concepts-target-cluster.eu-west-1.es.amazonaws.com/_snapshot/index-backups/snapshot-20170526/_restore
```

- All done! Delete the snapshot files from the target cluster's S3 bucket, unless you need to keep the backup.