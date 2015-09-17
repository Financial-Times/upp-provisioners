#Docker image to provision a cluster

##Building
```bash
# Build the image
docker build -t coco/coreos-up-setup .
```

## Set all the required variables

```bash
## Get a new etcd token for a new cluster, 5 refers to the number of initial boxes in the cluster:
## `curl https://discovery.etcd.io/new?size=5`
TOKEN_URL=https://discovery.etcd.io/xxxxxx

## Secret used during provision to decrypt keys - get it off your closest buddy!
VAULT_PASS=xxxxxxxx

## AWS API keys, get these off your buddy too
AWS_SECRET_ACCESS_KEY=xxxxxxx
AWS_ACCESS_KEY_ID=xxxxxxxx

## S3 bucket name to write to (up stack specific)
BINARY_WRITER_BUCKET=xxxxxxxx

## `uuidgen` each of these when creating new cluster
AWS_MONITOR_TEST_UUID=xxxxxxxx
UCS_MONITOR_TEST_UUID=xxxxxxxx

# [optional]
SERVICE_DEFINITION_LOCATION=https://raw.githubusercontent.com/Financial-Times/fleet/master/services.yaml
# make a unique identifier (you can use this to search your splunk logs as well)
ENVIRONMENT_TAG=xxxx
```

## Run the image
```bash
docker run --env "VAULT_PASS=$VAULT_PASS" \
    --env "TOKEN_URL=$TOKEN_URL" \
    --env "SERVICE_DEFINITION_LOCATION=$SERVICE_DEFINITION_LOCATION" \
    --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    --env "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    --env "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    --env "UCS_MONITOR_TEST_UUID=$UCS_MONITOR_TEST_UUID" coco/coreos-up-setup
```

