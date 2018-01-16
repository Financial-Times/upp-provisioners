# UPP Factset RDS Provisioning

* Provisioning script is currently only able to spin up aurora rds in eu-west-1

## Building the Docker image

The UPP Factset Provisioner can be built locally as a Docker image:

`docker build -t coco/upp-factset-provisioner:local .`

## Provisioning a cluster

The provisioning process will:

* Creates the database infrastructure: the cluster and db instance, cluster/instance parameter group and security group. And the Factset Loader infrastructure: ec2 instance(with non-configured loader application installed), 250GB mounted ebs volume and security group

How to run:

# Parameters

* MASTER_PASSWORD: Master password of RDS instance; must be 10-25 alpha numeric characters
* ENVIRONMENT_NAME: Used to distinguish between stacks
* ENVIRONMENT_TAG: Used for AWS resource tagging.
* VAULT_PASS: Used to read ansible provisioning data, can be found in last pass under upp-factset-provisioner
* AWS_ACCOUNT: Account in which to provision RDS; must be either content-test or content-prod

`docker pull coco/upp-factset-provisioner:latest`
```
docker run   \
    -e "MASTER_PASSWORD=$MASTER_PASSWORD" \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    coco/upp-factset-provisioner:latest /bin/bash provision.sh
```

- Note that the creation of DB cluster will take up to 15 mins.

## Manual Setup

There are a few manual steps which need to be run after successful provisioning of a stack which can be found [here](https://docs.google.com/document/d/1GEu0HKSgdq38bPX7RqRyWSftHhwCoMe-iW8nErbqy7A/edit?usp=sharing). The factset loader application is automatically installed on the ec2 instance via user data however the actual setup of needs to be configured on the box itself.

## Decommissioning a cluster

The de-commissioning process will:

* Deletes the database infrastructure: the cluster and db instance, cluster/instance parameter group and security group. And the Factset Loader infrastructure: ec2 instance with non-configured loader application installed, 250GB ebs volume and security group

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
