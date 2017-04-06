Docker image to provision a cluster
===================================

Building
--------

```bash
# Build the image
docker build -t coco/coco-pub-provisioner .
```


Set all the required variables
------------------------------

```bash
## You can also find all the setup stored in LastPass
## For PROD cluster
## LastPass: Publishing cluster provisioning setup
## For TEST cluster
## LastPass: TEST Publishing cluster provisioning setup

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

#to validate article are valid for publication
#the corresponding delivery cluster mat url for a given publish cluster.
export PAM_MAT_VALIDATION_URL=

#The HTTP credentials for calling the validation URL.
#Format: <username>:<password>
export PAM_MAT_VALIDATION_CREDENTIALS=

#The UUID used by PAM to check the read environment credentials.
#NOTE:currently this is the same uuid as used by the synthetic article monitor resource uuid and so guaranteed to exist.
export PAM_CREDENTIAL_VALIDATION_UUID

#to validate content placeholders (link-files) are valid for publication
#the corresponding delivery cluster mcpm url for a given publish cluster.
export PAM_MCPM_VALIDATION_URL=


# For publishing videos, the brightcove-notifier and brightcove-metadata-preprocessor must connect to the Brightcove API with an id like this: 47628783001
export BRIGHTCOVE_ACCOUNT_ID=

# You could find the keys in LastPass under the name: Brightcove
# Make sure to surround value in quotes " "
export BRIGHTCOVE_AUTH=

# The following variables are used by synthetic-article-publication-monitor and synthetic-list-publication-monitor in order to check the publication pipeline for articles and lists.
# The variables specify UUIDs and payloads that should be used to create synthetic publications by the two services.
export SYNTHETIC_ARTICLE_UUID=
export SYNTHETIC_ARTICLE_PAYLOAD=
export SYNTHETIC_LIST_UUID=

##URLs to Bertha endpoints for accessing to specific Google Spreadsheet data. Used in publishing cluster
##AUTHORS_BERTHA_URL refers to the spreadsheet of curated authors data.
##ROLES_BERTHA_URL refers to the spreadsheet of roles for curated authors.
##BRANDS_BERTHA_URL refers to the spreadsheet of roles for curated brands.
##MAPPINGS_BERTHA_URL refers to the spreadsheet of mappings between Brightcove video tags and TME IDs
export AUTHORS_BERTHA_URL=http://bertha.site.example/123456XYZ/Authors
export ROLES_BERTHA_URL=http://bertha.site.example/123456XYZ/Roles
export BRANDS_BERTHA_URL=http://bertha.site.example/123456XYZ/Brands
export MAPPINGS_BERTHA_URL=http://bertha.site.example/123456XYZ/Mapping
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
    coco/coco-pub-provisioner
```
