Docker image to provision a cluster
===================================

Building locally the image
--------------------------

```bash
# Build the image
docker build -t coco/coco-provisioner .
```


Set all the required variables
------------------------------

```bash
## You can also find all the setup stored in LastPass
## For PROD cluster
## LastPass: PROD Delivery cluster provisioning setup
## For TEST cluster
## LastPass: TEST Delivery cluster provisioning setup

## Get a new etcd token for a new cluster, 5 refers to the number of initial boxes in the cluster:
## `curl https://discovery.etcd.io/new?size=5`
export TOKEN_URL=`curl https://discovery.etcd.io/new?size=5`

## Secret used during provision to decrypt keys - stored in LastPass.
## Lastpass: coco-provisioner-ansible-vault-pass
export VAULT_PASS=

## AWS API keys for provisioning (not for use by services) - stored in LastPass.
## Lastpass: infraprod-coco-aws-provisioning-keys
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

## S3 bucket name to write image binaries to.
## Prod: com.ft.imagepublish.prod
## Pre-Prod: com.ft.coco-imagepublish.pre-prod
export BINARY_WRITER_BUCKET=

## `uuidgen` or set manually each of these when creating new cluster, otherwise: they will be automatically generated during the cluster setup (in this case it is not required to pass them at `docker run`)
export AWS_MONITOR_TEST_UUID=`uuidgen`
export COCO_MONITOR_TEST_UUID=`uuidgen`

## Base uri where your unit definition file and service files are expected to be.
export SERVICES_DEFINITION_ROOT_URI=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/

## make a unique identifier (this will be used for DNS tunnel, splunk, AWS tags)
export ENVIRONMENT_TAG=

## Set the FT environment type
## For PROD: p
## For TEST: t
export ENVIRONMENT_TYPE=

## Comma separated list of urls pointing to the message queue http proxy instances used to bridge platforms(UCS and coco). 
## This should always point at Prod - use separate service files to bridge from Test into lower environments.
export BRIDGING_MESSAGE_QUEUE_PROXY=https://kafka-proxy-iw-uk-p-1.glb.ft.com,https://kafka-proxy-iw-uk-p-2.glb.ft.com

## Comma separated username:password which will be used to authenticate(Basic auth) when connecting to the cluster over https.
## See Lastpass: 'CoCo Basic Auth' for current cluster values.
export CLUSTER_BASIC_HTTP_CREDENTIALS=

## Gateway content api hostname (not URL) to access UPP content that the cluster read endpoints (e.g. CPR & CPR-preview) are mapped to. 
## Defaults to Prod if left blank.
## Prod: api.ft.com
## Pre-Prod: test.api.ft.com
export API_HOST=

## UPP Gateway hostname and port (not URL) to access varnish.
## Prod: upp-uk-gateway.in.ft.com
## Pre-Prod or lower: upp-uk-gateway-test.in.ft.com
## Port will always be 443
export UPP_GATEWAY_HOST=
export UPP_GATEWAY_PORT=443

# Region to create the cluster.
export AWS_DEFAULT_REGION=eu-west-1

## Cname to access CES host in aws/ftp2
## Prod: ces.in.ft.com
## Pre-Prod or lower: ces-test.in.ft.com
export CES_HOST=

## The ElasticSearch domain used for concept-search
export AWS_ES_ENDPOINT=$AWS_ES_ENDPOINT=
```


Run the locally created image
-----------------------------

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
    -e "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    -e "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    -e "COCO_MONITOR_TEST_UUID=$COCO_MONITOR_TEST_UUID" \
    -e "BRIDGING_MESSAGE_QUEUE_PROXY=$BRIDGING_MESSAGE_QUEUE_PROXY" \
    -e "API_HOST=$API_HOST" \
    -e "CLUSTER_BASIC_HTTP_CREDENTIALS=$CLUSTER_BASIC_HTTP_CREDENTIALS" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "UPP_GATEWAY_HOST=$UPP_GATEWAY_HOST" \
    -e "UPP_GATEWAY_PORT=$UPP_GATEWAY_PORT" \
    -e "AWS_ES_ENDPOINT=$AWS_ES_ENDPOINT" \
    coco/coco-provisioner
```


