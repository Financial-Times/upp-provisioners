Docker image to provision a cluster
===================================


### Table of Contents
**[Tutorial](#tutorial)**  
**[For developer](#for-developers)**  
**[Set up SSH](#set-up-ssh)**  
**[Provision a delivery cluster](#provision-a-delivery-cluster)**  
**[Set up HTTPS support](#set-up-https-support)**  
**[Decommission an environment](#decommission-an-environment)**  
**[Coco Management Server](#coco-management-server)**  

Tutorial
--------

If you're looking to provision a new cluster, the [tutorial](Tutorial.md) might be a better place to start than here.

For developers
--------------

If you want to adjust provisioner's code, see [the developer readme](DEVELOPER_README.md) AND [the change process for provisioner](https://sites.google.com/a/ft.com/technology/systems/dynamic-semantic-publishing/coco/change-process-for-provisioner)

Set up SSH
----------

See [SSH_README.md](/SSH_README.md/)

Provision a delivery cluster
------------------------------

Currently, attempting to provision a cluster in `us-east-1` with an environment type of `t` causes the security group creation to fail.
Everything else works fine - `t` or `p` clusters in `eu-west-1`, and `p` clusters in `us-east-1`.

```bash
## Set all the environment variables required to provision a cluster. These variables are stored in LastPass
## For PROD cluster
## LastPass: PROD Delivery cluster provisioning setup
## For TEST cluster
## LastPass: TEST Delivery cluster provisioning setup

## Run docker command
docker run \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "TOKEN_URL=$TOKEN_URL" \
    -e "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    -e "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    -e "COCO_MONITOR_TEST_UUID=$COCO_MONITOR_TEST_UUID" \
    -e "BRIDGING_MESSAGE_QUEUE_PROXY=$BRIDGING_MESSAGE_QUEUE_PROXY" \
    -e "API_HOST=$API_HOST" \
    -e "CLUSTER_BASIC_HTTP_CREDENTIALS=$CLUSTER_BASIC_HTTP_CREDENTIALS" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    coco/coco-provisioner:v1.0.12

```

If you need a Docker runtime environment to provision a cluster you can set up [Coco Management Server](https://github.com/Financial-Times/coco-provisioner/blob/master/cloudformation/README.md) in AWS.

Decommission an environment
---------------------------

```
## Secret used during decommissioning to decrypt keys - stored in LastPass.
## Lastpass: coco-provisioner-ansible-vault-pass
export VAULT_PASS=

## AWS API keys for decommissioning - stored in LastPass.
## Lastpass: infraprod-coco-aws-provisioning-keys
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

## AWS region containing cluster to be decommissioned.
export AWS_DEFAULT_REGION=eu-west-1

## Cluster environment tag to decommission.
export ENVIRONMENT_TAG=
```



```sh
docker run \
  -e "VAULT_PASS=$VAULT_PASS" \
  -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
  -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
  -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  coco/coco-provisioner:v1.0.12 /bin/bash /decom.sh
```

Coco Management Server
---------------------------

See details in [cloudformation/README.md](https://github.com/Financial-Times/coco-provisioner/blob/master/cloudformation/README.md)

