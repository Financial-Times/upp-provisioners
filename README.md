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
    -e "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
    -e "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
    -e "COCO_MONITOR_TEST_UUID=$COCO_MONITOR_TEST_UUID" \
    -e "BRIDGING_MESSAGE_QUEUE_PROXY=$BRIDGING_MESSAGE_QUEUE_PROXY" \
    -e "API_HOST=$API_HOST" \
    -e "CLUSTER_BASIC_HTTP_CREDENTIALS=$CLUSTER_BASIC_HTTP_CREDENTIALS" \
    coco/coco-provisioner:v1.0.2

## If the cluster is running, set up HTTPS support (see below)
```

If you need a Docker runtime environment to provision a cluster you can set up [Coco Management Server](https://github.com/Financial-Times/coco-provisioner/blob/master/cloudformation/README.md) in AWS.

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
  coco/coco-provisioner:v1.0.2 /bin/bash /decom.sh
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

Coco Management Server
---------------------------

See details in [cloudformation/README.md](https://github.com/Financial-Times/coco-provisioner/blob/master/cloudformation/README.md)
