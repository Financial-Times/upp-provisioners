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
export TOKEN_URL=`curl https://discovery.etcd.io/new?size=5`

## Secret used during provision to decrypt keys - get it off your closest buddy!
export VAULT_PASS=xxxxxxxx

## AWS API keys, get these off your buddy too
export AWS_SECRET_ACCESS_KEY=xxxxxxx
export AWS_ACCESS_KEY_ID=xxxxxxxx

## S3 bucket name to write image binaries to (up stack specific)
export BINARY_WRITER_BUCKET=xxxxxxxx

## Only needed for decomissioning
## To create a cluster in another region, manually edit the provisioner
export AWS_DEFAULT_REGION=xxxxx

## `uuidgen` or set manually each of these when creating new cluster, otherwise: they will be automatically generated during the cluster setup (in this case it is not required to pass them at `docker run`)
export AWS_MONITOR_TEST_UUID=`uuidgen`
export COCO_MONITOR_TEST_UUID=`uuidgen`

## Base uri where your unit definition file and service files are expected to be.
export SERVICES_DEFINITION_ROOT_URI=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/
## make a unique identifier (this will be used for DNS tunnel, splunk, AWS tags)
export ENVIRONMENT_TAG=xxxx
## Comma separated list of urls pointing to the message queue http proxy instances used to bridge platforms(UCS and coco). Optional, defaults to Prod UCS proxy: https://kafka-proxy-iw-uk-p-1.glb.ft.com,https://kafka-proxy-iw-uk-p-2.glb.ft.com
export BRIDGING_MESSAGE_QUEUE_PROXY=xxxx #[Optional]
```

## Run the image
```bash
[sudo] docker run \
    --env "VAULT_PASS=$VAULT_PASS" \
    --env "TOKEN_URL=$TOKEN_URL" \
    --env "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    --env "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    --env "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    --env "COCO_MONITOR_TEST_UUID=$COCO_MONITOR_TEST_UUID" \
    --env "BRIDGING_MESSAGE_QUEUE_PROXY=$BRIDGING_MESSAGE_QUEUE_PROXY" coco-provisioner
```

## Setup HTTPS support
To access URLs from the cluster through HTTPS, we need to add support for this in the load balancer of this cluster

* log on to one of the machines in AWS
* pick a HC url, like `foo-up.ft.com`, (where `foo` is the ENVIRONMENT_TAG you defined for this cluster) and execute `dig foo-up.ft.com`
* the answer section will look something like this:

```
;; ANSWER SECTION:
foo-up.ft.com.        600    IN    CNAME    bar1426.eu-west-1.elb.amazonaws.com.
```

* This is the ELB for the cluster on which the HC is running: `bar1426.eu-west-1.elb.amazonaws.com`

* in the AWS console > EC2 > Load Balancers > search for the LB
* click on it > Listeners > Edit > Add HTTPS on instance port `80`
* to know which SSL certificate to choose, check what the LBs of other clusters (which have https enabled) are using
* save and try if it works, ex. `https://foo-up.ft.com`
* you can also remove HTTP support if needed

## Decomission environment
```sh
[sudo] docker run \
  --env "VAULT_PASS=$VAULT_PASS" \
  --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
  --env "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
  --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  coco-provisioner /bin/bash /decom.sh
```

