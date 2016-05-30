Docker image to provision a cluster
===================================


Tutorial
--------

If you're looking to provision a new cluster, the [tutorial](Tutorial.md) might be a better place to start than here. 


Set up SSH
----------

See [SSH_README.md](/SSH_README.md/)


Building
--------

```bash
# Build the image
docker build -t coco-provisioner .
```


Set all the required variables
------------------------------

```bash
## Get a new etcd token for a new cluster, 5 refers to the number of initial boxes in the cluster:
## `curl https://discovery.etcd.io/new?size=5`
export TOKEN_URL=`curl https://discovery.etcd.io/new?size=5`

## Secret used during provision to decrypt keys - get it off your closest buddy!
export VAULT_PASS=

## AWS API keys, get these off your buddy too
export AWS_SECRET_ACCESS_KEY=
export AWS_ACCESS_KEY_ID=

## S3 bucket name to write image binaries to (up stack specific)
export BINARY_WRITER_BUCKET=

## Only needed for decomissioning
## To create a cluster in another region, manually edit the provisioner
export AWS_DEFAULT_REGION=

## `uuidgen` or set manually each of these when creating new cluster, otherwise: they will be automatically generated during the cluster setup (in this case it is not required to pass them at `docker run`)
export AWS_MONITOR_TEST_UUID=`uuidgen`
export COCO_MONITOR_TEST_UUID=`uuidgen`

## Base uri where your unit definition file and service files are expected to be.
export SERVICES_DEFINITION_ROOT_URI=https://raw.githubusercontent.com/Financial-Times/up-service-files/master/
## make a unique identifier (this will be used for DNS tunnel, splunk, AWS tags)
export ENVIRONMENT_TAG=
## Comma separated list of urls pointing to the message queue http proxy instances used to bridge platforms(UCS and coco). Optional, defaults to Prod UCS proxy: https://kafka-proxy-iw-uk-p-1.glb.ft.com,https://kafka-proxy-iw-uk-p-2.glb.ft.com
export BRIDGING_MESSAGE_QUEUE_PROXY= #[Optional]
```


Run the image
-------------

```bash
docker run \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "TOKEN_URL=$TOKEN_URL" \
    -e "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    -e "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    -e "COCO_MONITOR_TEST_UUID=$COCO_MONITOR_TEST_UUID" \
    -e "BRIDGING_MESSAGE_QUEUE_PROXY=$BRIDGING_MESSAGE_QUEUE_PROXY" coco-provisioner
```


Set up HTTPS support
--------------------

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

Decommission an environment
---------------------------

```sh
docker run \
  -e "VAULT_PASS=$VAULT_PASS" \
  -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
  -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
  -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  coco-provisioner /bin/bash /decom.sh
```

Sometimes cleanup takes a long time and ELBs/Security Groups still get left behind. Other ways to clean up:

```sh
# List all coreos security groups
aws ec2 describe-security-groups | jq -r '.SecurityGroups[] | .GroupName + " " + .GroupId' | grep coreos

# Delete coreos security groups not in use, does not filter - will fail on any group that is being used
aws ec2 describe-security-groups | jq -r '.SecurityGroups[] | .GroupName + " " + .GroupId' | grep coreos | awk '{print $2}' | xargs -I {} -n1 sh -c 'aws ec2 delete-security-group --group-id {} || echo {} is active'

# Delete ELBs that have no instances AND there are no instances with the same group name (stopped) as the ELB
aws elb describe-load-balancers | jq -r '.LoadBalancerDescriptions[] | select(.Instances==[]) | .LoadBalancerName' | grep coreos | xargs -I {} sh -c "aws ec2 describe-instances --filters "Name=tag-key,Values=coco-environment-tag" | jq -e '.Reservations[].Instances[].SecurityGroups[] | select(.GroupName==\"{}\")' >/dev/null 2>&1 || echo {}" | xargs -n1 -I {} aws elb delete-load-balancer --load-balancer-name {}
```

