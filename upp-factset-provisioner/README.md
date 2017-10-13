# UPP Factset RDS Provisioning

* Provisioning script is currently only able to spin up aurora rds in eu-west-1

## Building the Docker image

The UPP Factset Provisioner can be built locally as a Docker image:

`docker build -t upp-factset-provisioner:local .`

## Provisioning a cluster

The provisioning process will:

* Creates an aurora cluster, db subnet group and cluster parameter group in eu-west-1 using the cloud formation template

How to run:

# Parameters

* MASTER_PASSWORD: Master password of RDS instance; must be 10-25 alpha numeric characters
* ENVIRONMENT_NAME: Used to distinguish between stacks, stack name will be upp-factset-data-{ENVIRONMENT_NAME}
* VAULT_PASS: Used to read ansible provisioning data, can be found in last pass under upp-factset-provisioner
* AWS_ACCOUNT: Account in which to provision RDS; must be either content-test or content-prod

```
docker run   \
    -e "MASTER_PASSWORD=$MASTER_PASSWORD" \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    coco/upp-factset-provisioner:local /bin/bash provision.sh
```

- Note that the creation of DB cluster will take up to 15 mins.

## Decommissioning a cluster

The de-commissioning process will:

* Delete the Cluster and db instance, cluster parameter group and subnet group

How to run:

- Get the environment variables from the **User upp-factset-provisioner** LastPass note in the **Shared-UPP Credentials & Services Login Details** folder.
- Run the following docker command

```
docker run   \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    coco/upp-factset-provisioner:local /bin/bash decom.sh
```
