# UPP Factset RDS Provisioning

* Provisioning script is currently only able to spin up aurora rds in eu-west-1

## Building the Docker image

The UPP Factset Provisioner can be built locally as a Docker image:

`docker build -t coco/upp-factset-provisioner:local .`

## Provisioning a cluster

The provisioning process will:

* Creates the database infrastructure: the cluster and db instance, cluster/instance parameter group and security group. And the Factset Loader infrastructure: ec2 instance(with non-configured loader application installed), 250GB mounted ebs volume and security group

How to run:

- Generate credentials for the IAM user `upp-factset-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.

# Parameters

* MASTER_PASSWORD: Master password of RDS instance; must be 10-25 alpha numeric characters
* ENVIRONMENT_NAME: Used to distinguish between stacks
* ENVIRONMENT_TAG: Used for AWS resource tagging.
* VAULT_PASS: Used to read ansible provisioning data, can be found in last pass under **UPP Factset Provisioner**
* AWS_ACCOUNT: Account in which to provision RDS; must be either content-test or content-prod
* AWS_ACCESS_KEY: Access key of the IAM provisioner user
* AWS_SECRET_ACCESS_KEY: Secret Access key of the IAM provisioner user
* FT_RESOURCES_SECURITY_GROUP_ID: ID of the FT resources security group in the VPC you are provisioning the cluster (please refer to [FT security groups](https://tech.in.ft.com/tech-topics/amazon-web-services/service-guides/ec2/creating_ec2_instances#security-groups) for more info)

`docker pull coco/upp-factset-provisioner:latest`
```
docker run   \
    -e "MASTER_PASSWORD=$MASTER_PASSWORD" \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "FT_RESOURCES_SECURITY_GROUP_ID=$FT_RESOURCES_SECURITY_GROUP_ID" \
    coco/upp-factset-provisioner:latest /bin/bash provision.sh
```

- Note that the creation of DB cluster will take up to 15 mins.

## Manual Setup

There are a few manual steps which need to be run after successful provisioning of a stack which can be found [here](https://docs.google.com/document/d/1GEu0HKSgdq38bPX7RqRyWSftHhwCoMe-iW8nErbqy7A/edit?usp=sharing). The installation and actual setup of the factset loader application needs to be done on the box itself.

## Decommissioning a cluster

The de-commissioning process will:

* Deletes the database infrastructure: the cluster and db instance, cluster/instance parameter group and security group. And the Factset Loader infrastructure: ec2 instance with non-configured loader application installed, 250GB ebs volume and security group

How to run:

- Generate credentials for the IAM user `upp-factset-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.
- Get the environment variables from the **UPP Factset Provisioner** LastPass note in the **Shared-UPP Credentials & Services Login Details** folder.
- Run the following docker command

```
docker run   \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    coco/upp-factset-provisioner:local /bin/bash decom.sh
```

# Provisioning only Factset Loader EC2 instance

Yon can use the following steps in case you need to only provision Factset Loader EC2 instance with non-configured loader application installed, 250GB ebs volume and security group.

How to run:

- Generate credentials for the IAM user `upp-factset-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.

# Parameters

* ENVIRONMENT_NAME: Used to distinguish between stacks
* ENVIRONMENT_TAG: Used for AWS resource tagging.
* VAULT_PASS: Used to read ansible provisioning data, can be found in last pass under **UPP Factset Provisioner**
* AWS_ACCOUNT: Account in which to provision RDS; must be either content-test or content-prod
* AWS_ACCESS_KEY: Access key of the IAM provisioner user
* AWS_SECRET_ACCESS_KEY: Secret Access key of the IAM provisioner user
* LOADER_SECURITY_GROUP_ID: ID of the security group created when provisioning the whole Factset infrastructure (please refer to step [Provisioning a cluster](#provisioning-a-cluster)) 
* FT_RESOURCES_SECURITY_GROUP_ID: ID of the FT resources security group in the VPC you are provisioning the ec2 instance (please refer to [FT security groups](https://cloudenablement.in.ft.com/aws/service_guides/ec2/creating_ec2_instances/#security-groups) for more info)

`docker pull coco/upp-factset-provisioner:latest`
```
docker run   \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "LOADER_SECURITY_GROUP_ID=$LOADER_SECURITY_GROUP_ID" \
    -e "FT_RESOURCES_SECURITY_GROUP_ID=$FT_RESOURCES_SECURITY_GROUP_ID" \
    coco/upp-factset-provisioner:latest /bin/bash provision-loader.sh
```

## Manual Setup

There are a few manual steps which need to be run after successful provisioning of the factset loader instance which can be found [here](https://docs.google.com/document/d/1GEu0HKSgdq38bPX7RqRyWSftHhwCoMe-iW8nErbqy7A/edit?usp=sharing). The installation and actual setup of the factset loader application needs to be done on the box itself.

## Decommissioning only Factset Loader EC2 instance

How to run:

- Generate credentials for the IAM user `upp-factset-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.
- Get the environment variables from the **UPP Factset Provisioner** LastPass note in the **Shared-UPP Credentials & Services Login Details** folder.
- Run the following docker command

```
docker run   \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    coco/upp-factset-provisioner:local /bin/bash decom-loader.sh
```
