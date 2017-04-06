 [![GitHub release](https://img.shields.io/badge/version-v1.0.15-green.svg?style=flat)](https://github.com/Financial-Times/coco-pub-provisioner/releases)

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

If you're looking to provision a new pub cluster, the [tutorial](Tutorial.md) might be a better place to start than here.

For developers
--------------

If you want to adjust provisioner's code, see [the developer readme](DEVELOPER_README.md) AND [the change process for provisioner](https://sites.google.com/a/ft.com/technology/systems/dynamic-semantic-publishing/coco/change-process-for-provisioner)

If you want to set keys in the vault which are multiline or too long, see [the current workaround](LONG_AND_MULTILINE_KEYS.md).

Set up SSH
----------

See [SSH_README.md](/SSH_README.md/)

Provision a publishing cluster
------------------------------

Currently, attempting to provision a cluster in `us-east-1` with an environment type of `t` causes the security group creation to fail.
Everything else works fine - `t` or `p` clusters in `eu-west-1`, and `p` clusters in `us-east-1`.

```bash
## Set all the environment variables required to provision a cluster. These variables are stored in LastPass
## For PROD cluster
## LastPass: PROD Publishing cluster provisioning setup
## For TEST cluster
## LastPass: TEST Publishing cluster provisioning setup
## SET PAM_MAT_VALIDATION_URL  to be a request to correspoding delivery cluster MAT content-transform end point

## Pull latest stable image and run docker command
docker pull coco/coco-pub-provisioner:latest
docker run \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "TOKEN_URL=$TOKEN_URL" \
    -e "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "API_HOST=$API_HOST" \
    -e "CLUSTER_BASIC_HTTP_CREDENTIALS=$CLUSTER_BASIC_HTTP_CREDENTIALS" \
    -e "DELIVERY_CLUSTERS_URLS=$DELIVERY_CLUSTERS_URLS" \
    -e "S3_IMAGE_BUCKET_URLS=$S3_IMAGE_BUCKET_URLS" \
    -e "DELIVERY_CLUSTERS_HTTP_CREDENTIALS=$DELIVERY_CLUSTERS_HTTP_CREDENTIALS" \
    -e "BINARY_S3_BUCKET=$BINARY_S3_BUCKET" \
    -e "PAM_MAT_VALIDATION_URL=$PAM_MAT_VALIDATION_URL" \
    -e "PAM_MAT_VALIDATION_CREDENTIALS=$PAM_MAT_VALIDATION_CREDENTIALS" \
    -e "PAM_CREDENTIAL_VALIDATION_UUID=$PAM_CREDENTIAL_VALIDATION_UUID" \
    -e "PAM_MCPM_VALIDATION_URL=$PAM_MCPM_VALIDATION_URL" \
    -e "SYNTHETIC_ARTICLE_UUID=$SYNTHETIC_ARTICLE_UUID" \
    -e "SYNTHETIC_ARTICLE_PAYLOAD=$SYNTHETIC_ARTICLE_PAYLOAD" \
    -e "SYNTHETIC_LIST_UUID=$SYNTHETIC_LIST_UUID" \
    -e "BRIGHTCOVE_ACCOUNT_ID=$BRIGHTCOVE_ACCOUNT_ID" \
    -e "BRIGHTCOVE_AUTH=$BRIGHTCOVE_AUTH" \
    -e "AUTHORS_BERTHA_URL=$AUTHORS_BERTHA_URL" \
    -e "ROLES_BERTHA_URL=$ROLES_BERTHA_URL" \
    -e "BRANDS_BERTHA_URL=$BRANDS_BERTHA_URL" \
    -e "MAPPINGS_BERTHA_URL=$MAPPINGS_BERTHA_URL" \
    -e "CONCEPTS_RW_S3_BUCKET=$CONCEPTS_RW_S3_BUCKET" \
    -e "CONCEPTS_RW_S3_BUCKET_REGION=$CONCEPTS_RW_S3_BUCKET_REGION" \
     coco/coco-pub-provisioner:latest

## Note - if you require a specific version of the docker image, you can replace 'latest' with 'v1.0.17'

```

If you need a Docker runtime environment to provision a cluster you can set up [Coco Management Server](https://github.com/Financial-Times/coco-pub-provisioner/blob/master/cloudformation/README.md) in AWS.

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
docker pull coco/coco-pub-provisioner:latest
docker run \
  -e "VAULT_PASS=$VAULT_PASS" \
  -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
  -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
  -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  coco/coco-pub-provisioner:latest /bin/bash /decom.sh

## Note - if you require a specific version of the docker image, you can replace 'latest' with 'v1.0.17'

```


Coco Management Server
---------------------------

See details in [cloudformation/README.md](https://github.com/Financial-Times/coco-pub-provisioner/blob/master/cloudformation/README.md)
