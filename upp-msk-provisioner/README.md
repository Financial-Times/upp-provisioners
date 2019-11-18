# MSK Cluster provioner

This provisioner creates an AWS MSK cluster.

## Create a cluster

Checklist:

- Create cluster configuration in *ansible/vars*.
- Apply the cluster.

## Apply a cluster

```sh
cd msk-provisioner

# Build the docker image
docker build -t msk-provisioner:local .

# Fill in the AWS credentials
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Fill in the required details.
export CLUSTER_NAME="upp-poc-kafka"
export ENVIRONMENT_TYPE="d"


docker run \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CLUSTER_NAME=$CLUSTER_NAME" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    msk-provisioner:local /bin/bash apply.sh

```

The creation takes around 15-20 minutes.

## Delete a cluster

Use the AWS console to delete the existing stack or the CLI command below.

```sh
cd msk-provisioner

# Build the docker image
docker build -t msk-provisioner:local .

# Fill in the AWS credentials
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Fill in the required details.
export CLUSTER_NAME="upp-poc-kafka"
export ENVIRONMENT_TYPE="d"

docker run \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CLUSTER_NAME=$CLUSTER_NAME" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    msk-provisioner:local /bin/bash delete.sh

```

## Update a cluster configuration

This is manual task since the AWS services in this regard are limited. Here are
few of the limitations:

- Cluster configuration cannot be managed by CF.
- Cluster configuration cannot be deleted.
- Cluster configuration can be managed only by AWS CLI.

To update a cluster see the following AWS pages:

1. [Amazon MSK Configuration Operations](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-operations.html)
2. [Update the Configuration of an Amazon MSK cluster](https://docs.aws.amazon.com/msk/latest/developerguide/msk-update-cluster-cofig.html)

After manually appling the configuration update cluster's configuration at
*vars* and run the *apply.sh* via the provisioner to align the configuration.

## Change/Apply configuration for MSK cluster

Currently actions related to MSK configurations are available only manual (via CLI or AWS API). Current MSK configration is in file ./kafka-config. AWS documentation for [MSK configuration actions](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-operations.html).