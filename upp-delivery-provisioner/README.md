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

You can provision `t` or `p` clusters in `eu-west-1` and `us-east-1`.

```bash
## Set all the environment variables required to provision a cluster. These variables are stored in LastPass
## For PROD cluster
## LastPass: PROD Delivery cluster provisioning setup
## For TEST cluster
## LastPass: TEST Delivery cluster provisioning setup

## Pull latest stable image and run docker command
docker pull coco/upp-delivery-provisioner:latest
docker run \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "TOKEN_URL=$TOKEN_URL" \
    -e "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    -e "GENERIC_RW_BUCKET=$GENERIC_RW_BUCKET" \
    -e "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    -e "COCO_MONITOR_TEST_UUID=$COCO_MONITOR_TEST_UUID" \
    -e "BRIDGING_MESSAGE_QUEUE_PROXY=$BRIDGING_MESSAGE_QUEUE_PROXY" \
    -e "API_HOST=$API_HOST" \
    -e "UPP_GATEWAY_HOST=$UPP_GATEWAY_HOST" \
    -e "UPP_GATEWAY_PORT=$UPP_GATEWAY_PORT" \
    -e "NEO4J_READ_URL=$NEO4J_READ_URL" \
    -e "NEO4J_WRITE_URL=$NEO4J_WRITE_URL" \
    -e "CES_HOST=$CES_HOST" \
    -e "CES_CREDENTIALS=$CES_CREDENTIALS" \
    -e "CLUSTER_BASIC_HTTP_CREDENTIALS=$CLUSTER_BASIC_HTTP_CREDENTIALS" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "AWS_ES_ENDPOINT=$AWS_ES_ENDPOINT" \
    -e "AWS_ES_CONTENT_ENDPOINT=$AWS_ES_CONTENT_ENDPOINT" \
    -e "METHODE_API=$METHODE_API" \
    coco/upp-delivery-provisioner:latest

## Note - if you require a specific version of the docker image, you can replace 'latest' with 'v1.0.17'

```

If you need a Docker runtime environment to provision a cluster you can set up [Coco Management Server](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-delivery-provisioner/cloudformation/README.md) in AWS.

Decommission an environment
---------------------------
Note: make sure to disable termination protection for each machine before, otherwise the decom will not work: find your instances in AWS console, and for each of them right click -> Instance Settings -> Change Termination Protection -> Yes, Disable.
```
## Secret used during decommissioning to decrypt keys - stored in LastPass.
## Lastpass: upp-delivery-provisioner-ansible-vault-pass
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
docker pull coco/upp-delivery-provisioner:latest
docker run \
  -e "VAULT_PASS=$VAULT_PASS" \
  -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
  -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
  -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  coco/upp-delivery-provisioner:latest /bin/bash /decom.sh

## Note - if you require a specific version of the docker image, you can replace 'latest' with 'v1.0.17'
```

Coco Management Server
---------------------------

See details in [cloudformation/README.md](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-delivery-provisioner/cloudformation/README.md)
