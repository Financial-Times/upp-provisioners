Docker image to provision a cluster
===================================

Adding or updating etcd keys
----------------------------

Due to the 16kb limit on AWS user data, we can no longer pass our full cloud-config to the instances via user data.

To work around this, we now have a smaller [initial_user_data.yaml](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/ansible/userdata/initial_user_data.yaml), which:

* Stores the provisioning secrets and environment variables on the instance
* Downloads the [persistent_instance_user_data.yaml](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/ansible/userdata/persistent_instance_user_data.yaml) templates
* Downloads and runs [substitute-ft-env-variables.sh](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/sh/substitute-ft-env-variables.sh) to substitute the secrets and environment variables into the template
* Triggers a second cloud-config run to properly configure the cluster, using the fully expanded template

If you need to add or update etcd keys (or any other environment variables used as part of cloud-config), you must add the variable in 5 locations:

* LastPass, under `TEST Publishing cluster provisioning setup` & `PROD Publishing cluster provisioning setup`
* The [README](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/README.md) and [DEVELOPER_README](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/DEVELOPER_README.md).
* [provision.sh](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/provision.sh)
* [initial_user_data.yaml](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/ansible/userdata/initial_user_data.yaml)
* [persistent_instance_user_data.yaml](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-pub-provisioner/ansible/userdata/persistent_instance_user_data.yaml)

Note that because the provisioned instances download `persistent_instance_user_data.yaml` from GitHub, any local or unpushed changes will NOT be picked up when provisioning.  
Any changes that you want to test **must** be pushed to a branch before provisioning.

Building
--------

```bash
# Build the image
docker build -t coco/upp-pub-provisioner:local .
```


Set all the required variables
------------------------------

```bash
## You can also find all the setup stored in LastPass
## For PROD cluster
## LastPass: Publishing cluster provisioning setup
## For TEST cluster
## LastPass: TEST Publishing cluster provisioning setup

## Get the name of the current branch, so that the instances pull the correct user data templates
## This is only relevant when testing branch changes to the provisioner itself - not required for normal provisioning
## If not supplied or run while not in a git repo, provision.sh will default to master
export BRANCH_NAME=`git symbolic-ref HEAD | sed 's|refs/heads/||'`

## Get a new etcd token for a new cluster, 3 refers to the number of initial boxes in the cluster:
## `curl https://discovery.etcd.io/new?size=3`
export TOKEN_URL=`curl -s https://discovery.etcd.io/new?size=3`

## Secret used during provision to decrypt keys - stored in LastPass.
## Lastpass: coco-provisioner-ansible-vault-pass
export VAULT_PASS=

## AWS API keys for provisioning (not for use by services) - stored in LastPass.
## Lastpass: infraprod-coco-aws-provisioning-keys
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

## Base uri where your unit definition file and service files are expected to be.
export SERVICES_DEFINITION_ROOT_URI=https://raw.githubusercontent.com/Financial-Times/pub-service-files/master/

## make a unique identifier (this will be used for DNS tunnel, splunk, AWS tags)
export ENVIRONMENT_TAG=

## Set the FT environment type
## For PROD: p
## For TEST: t
export ENVIRONMENT_TYPE=

## The public dns name for the cluster type, regardless of the region it has been provisioned in.
## It is used to define whether a cluster is serving traffic.
## For PROD: publishing-prod-up.ft.com
## For PRE-PROD: pub-pre-prod-up.ft.com
## For your domain cluster, simply use the DNS name formed by the rule: ${CLUSTER_NAME}-up.ft.com
export DNS_ADDRESS=

## Comma separated username:password which will be used to authenticate(Basic auth) when connecting to the cluster over https.
## See Lastpass: 'CoCo Basic Auth' for current cluster values.
export CLUSTER_BASIC_HTTP_CREDENTIALS=

## Gateway content api hostname (not URL) to access UPP content that the cluster read endpoints (e.g. CPR & CPR-preview) are mapped to.
## Defaults to Prod if left blank.
## Prod: api.ft.com
## Pre-Prod: test.api.ft.com
export API_HOST=

# Region to create the cluster.
export AWS_DEFAULT_REGION=eu-west-1

# The following variable specifies URLs for read access to the delivery clusters, which are required by publishing monitoring services.
# The value should be specified by the following syntax: <env-tag1>:<delivery-cluster-url1>,<env-tag2>:<delivery-cluster-url2>,...,<env-tagN>:<delivery-cluster-urlN>
export DELIVERY_CLUSTERS_URLS='prod-uk:https://prod-uk.site.com/,prod-us:https://prod-uk.site.com/'

# The following variable is similar to the one above, specifying URL to S3 buckets required for image binary publish monitoring checks.
# The value should be specified by the following syntax: <env-tag1>:<s3-url1>,<env-tag2>:<s3-url2>,...,<env-tagN>:<s3-urlN>
# Note: the <env-tag1>, <env-tag2>,...,<env-tagN> should be the same as for DELIVERY_CLUSTERS_URLS environment variable
export S3_IMAGE_BUCKET_URLS='prod-uk:http://com.ft.imagepublish.prod.s3.amazonaws.com/,prod-us:http://com.ft.imagepublish.prod-us.s3.amazonaws.com/'

# The following variable specifies HTTP credentials to communicate to delivery clusters.
# The value should be specified by the following syntax: <env-tag1>:<username1>:<password1>,<env-tag2>:<username2>:<password2>,...,<env-tagN>:<usernameN>:<passwordN>
export DELIVERY_CLUSTERS_HTTP_CREDENTIALS='prod-uk:user1:passwd1,prod-us:user2:passwd2'

#The following variable is used by PAM to make publishing checks on images
#the value for all non prod clusters is the pre-prod bucket
export BINARY_S3_BUCKET=

#to validate articles are valid for publication
#the corresponding delivery cluster article mapper url for a given publish cluster.
export PAM_MAM_VALIDATION_URL=

#methode content-placeholders
export PAM_MCPM_VALIDATION_URL=

#methode images
export PAM_MIMM_VALIDATION_URL=

#methode list
export PAM_MLM_VALIDATION_URL=

#methode articles with internal components
export PAM_MAICM_VALIDATION_URL=

#video
export PAM_VIDEO_VALIDATION_URL=

#wordpress articles
export PAM_WAM_VALIDATION_URL=

#PAM needs an API key for Notifications-Push requests
export PAM_API_KEY=

#The HTTP credentials for calling the validation URL.
#Format: <username>:<password>
export PAM_VALIDATOR_CREDENTIALS=

#The UUID used by PAM to check the read environment credentials.
#NOTE:currently this is the same uuid as used by the synthetic article monitor resource uuid and so guaranteed to exist.
export PAM_CREDENTIAL_VALIDATION_UUID

# The following variables are used by synthetic-article-publication-monitor and synthetic-list-publication-monitor in order to check the publication pipeline for articles and lists.
# The variables specify UUIDs and payloads that should be used to create synthetic publications by the two services.
export SYNTHETIC_ARTICLE_UUID=
export SYNTHETIC_ARTICLE_PAYLOAD=
export SYNTHETIC_LIST_UUID=

##URLs to Bertha endpoints for accessing to specific Google Spreadsheet data. Used in publishing cluster
##AUTHORS_BERTHA_URL refers to the spreadsheet of curated authors data.
##ROLES_BERTHA_URL refers to the spreadsheet of roles for curated authors.
export AUTHORS_BERTHA_URL=http://bertha.site.example/123456XYZ/Authors
export ROLES_BERTHA_URL=http://bertha.site.example/123456XYZ/Roles

# The following variables are used by the concordance-rw-dynamodb. If you leave them blank the service will be unhealthy
# CONCORDANCES_DYNAMODB_TABLE expects the name of the table that concordances will be written too.
# CONCORDANCES_TOPIC_ARN is the SNS topic to post a notification to after successful write to db.
export CONCORDANCES_DYNAMODB_TABLE=[When provisioned using the provisioner follows the naming convention upp-concordance-store-{env}]
export CONCORDANCES_TOPIC_ARN=[The topic name(which is included in the ARN) follows the naming convention upp-concept-publishing-{env}-SNSTopic]

# The following variables are used by the smartlogic-notifier
# The base_url should be the smartlogic api url, the model determines which workflow is your source of truth and the api key is used in place of basic auth
export SMARTLOGIC_BASE_URL=
export SMARTLOGIC_MODEL=
export SMARTLOGIC_API_KEY=
```

Run the image
-------------

Currently, attempting to provision a cluster in `us-east-1` with an environment type of `t` causes the security group creation to fail.
Everything else works fine - `t` or `p` clusters in `eu-west-1`, and `p` clusters in `us-east-1`.

```bash
docker run \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "TOKEN_URL=$TOKEN_URL" \
    -e "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "DNS_ADDRESS=$DNS_ADDRESS" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "API_HOST=$API_HOST" \
    -e "CLUSTER_BASIC_HTTP_CREDENTIALS=$CLUSTER_BASIC_HTTP_CREDENTIALS" \
    -e "CAROUSEL_BUCKET=$CAROUSEL_BUCKET" \
    -e "CAROUSEL_ENABLED=$CAROUSEL_ENABLED" \
    -e "DELIVERY_CLUSTERS_URLS=$DELIVERY_CLUSTERS_URLS" \
    -e "S3_IMAGE_BUCKET_URLS=$S3_IMAGE_BUCKET_URLS" \
    -e "DELIVERY_CLUSTERS_HTTP_CREDENTIALS=$DELIVERY_CLUSTERS_HTTP_CREDENTIALS" \
    -e "BINARY_S3_BUCKET=$BINARY_S3_BUCKET" \
    -e "PAM_MAM_VALIDATION_URL=$PAM_MAM_VALIDATION_URL" \
    -e "PAM_VALIDATOR_CREDENTIALS=$PAM_VALIDATOR_CREDENTIALS" \
    -e "PAM_API_KEY=$PAM_API_KEY" \
    -e "PAM_CREDENTIAL_VALIDATION_UUID=$PAM_CREDENTIAL_VALIDATION_UUID" \
    -e "PAM_MCPM_VALIDATION_URL=$PAM_MCPM_VALIDATION_URL" \
    -e "PAM_MIMM_VALIDATION_URL=$PAM_MIMM_VALIDATION_URL" \
    -e "PAM_MLM_VALIDATION_URL=$PAM_MLM_VALIDATION_URL" \
    -e "PAM_MAICM_VALIDATION_URL=$PAM_MAICM_VALIDATION_URL" \
    -e "PAM_VIDEO_VALIDATION_URL=$PAM_VIDEO_VALIDATION_URL" \
    -e "PAM_WAM_VALIDATION_URL=$PAM_WAM_VALIDATION_URL" \
    -e "SYNTHETIC_ARTICLE_UUID=$SYNTHETIC_ARTICLE_UUID" \
    -e "SYNTHETIC_ARTICLE_PAYLOAD=$SYNTHETIC_ARTICLE_PAYLOAD" \
    -e "SYNTHETIC_LIST_UUID=$SYNTHETIC_LIST_UUID" \
    -e "AUTHORS_BERTHA_URL=$AUTHORS_BERTHA_URL" \
    -e "ROLES_BERTHA_URL=$ROLES_BERTHA_URL" \
    -e "BRANCH_NAME=$BRANCH_NAME" \
    coco/upp-pub-provisioner:local
```

Decommissioning
---------------

```bash
docker run \
  -e "VAULT_PASS=$VAULT_PASS" \
  -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
  -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
  -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  coco/upp-pub-provisioner:local /bin/bash /decom.sh
```
