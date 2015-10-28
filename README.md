#Docker image to provision a cluster

*Note if your user is not part of the docker group, run commands with sudo.*

## Set up SSH

See [SSH_README.md](/SSH_README.md/)

## [optional] USE LATEST STABLE AMI

Check [this page](https://coreos.com/os/docs/latest/booting-on-ec2.html) for the HVM ami-xxxxxx id
for your EC2 region.

You can replace the vars->ami value in [ansible/aws_coreos_site.yml](/ansible/aws_coreos_site.yml/)
with this latest id.

## Building
```bash
# Build the image
[sudo] docker build -t coco-provisioner .
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

## Base uri where your unit definition file and service files are expected to be.
SERVICES_DEFINITION_ROOT_URI=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/
## make a unique identifier (this will be used for DNS tunnel, splunk, AWS tags)
ENVIRONMENT_TAG=xxxx
```

## Run the image
```bash
[sudo] docker run --env "VAULT_PASS=$VAULT_PASS" \
    --env "TOKEN_URL=$TOKEN_URL" \
    --env "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    --env "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    --env "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    --env "UCS_MONITOR_TEST_UUID=$UCS_MONITOR_TEST_UUID" coco-provisioner
```

## Decomission environment
```sh
[sudo] docker run --env "TOKEN_URL=$TOKEN_URL" \
  --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
  coco-provisioner /bin/bash /decom.sh
```

