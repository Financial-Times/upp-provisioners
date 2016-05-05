# CoCo Tutorial

## Goals and overview
By the time you finish this you will have deployed your own private CoCo cluster, figured out how to investigate problems and rectify them.

At a high level you will:
1. Create a branch of the services to be run
1. Create a new CoCo cluster
1. Nurse it to health
1. Deploy a new service
1. Decommission the cluster

## Creating an environment branch

1. Checkout the [up-service-file](https://github.com/Financial-Times/up-service-files) repository

```bash
git clone git@github.com:Financial-Times/up-service-files.git
```

This repository contains definitions of the services you'll deploy.

1. Create a branch

Since we want to deploy a 'private' service which may or may not get deployed to production environment, you need to create a branch from master. Replace myBranch with something more imaginative:

```bash
cd up-service-files
git checkout -b myBranch
git push --set-upstream myBranch
```

You should periodically re-sync your private by issuing a `git rebase master` within your branch.

## Create a CoCo cluster
There are a set of instructions in the (/README.md) file.
1. Setup a local instance of docker.

  The CoCo Provisioner is a docker image, so ensure you have docker installed and are able to carry out simple docker commands. If you feel like it there is a 'native' docker available for Windows and OSX, see [Beta programme](https://beta.docker.com/docs/features-overview/) for details.

1. Clone this repository

  ```bash
  git clone git@github.com:Financial-Times/coco-provisioner.git
  ```
1. Build this docker image

  ```bash
  docker build .
  ```

1. Set configuration parameters

  CoCo Provisioner needs to know a few details:

  | ENV VAR | Comments | Suggested / default value |
  | --- | --- | --- |
  | SERVICES_DEFINITION_ROOT_URI | Base location of service definitions etc,
  | TOKEN_URL | The etcd token used to identify this etcd cluster | `curl https://discovery.etcd.io/new?size=5` |
  | AWS_MONITOR_TEST_UUID |  | `curl -s  https://www.uuidgenerator.net/api/version4` |
  | COCO_MONITOR_TEST_UUID |  | `curl -s  https://www.uuidgenerator.net/api/version4` |


1. Run the provisioner

  You may need to run this as root, if this is the case `sudo` first
  ```bash
docker run \
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

1. All being well you will now have a CoCo cluster. It is unlikely to be heathy when it starts. To verify that the cluster has been started goto the [AWS console](http://awslogin.internal.ft.com/) and goto the eu-west-1 view of running EC2 instances. In the filter field enter the value of the `ENVIRONMENT_TAG` used to create the cluster.

  *Wait for all your servers to be in a running state before you move on*

1. (*Recommended, but Optional*) Currently the cluster will only available via http, which is obviously not secure. Since all the clusters share the same authentication token, you should really add an HTTPS listener to the ELB and remove the HTTP listener.

  Navigate to *Load Balancers* in the AWS EC2 console and sort them by date created. You load balancer should be at the top, but to be sure you are modifying the correct one, check the tags associated with it and you should see your `ENVIRONMENT_TAG`.

  Edit the HTTP endpoints and add a new HTTPS listener on port 443 that directs to port 80 (over HTTP) using the `wildcard-ft-com` certificate.

  Remove the HTTP listener

1. Creating the cluster should have registered some new host names with our DNS provider:

  | _ENVIRONMENT_TAG_-up.ft.com | HTTP endpoint for you cluster |
  | _ENVIRONMENT_TAG_-tunnel-up.ft.com | Allowed you to SSH into your cluster |

  Check you can resolve these hosts by running a `dig` or `nslookup`

*Congratulations, you've built a CoCo cluster*

_That was the easy bit ! Now it's time to nurse it to health_

# Nursing CoCo to health

1. Checking the deployer

  The deployer, as it's name suggests, is responsible for deploying services to the cluster. If this is deploying or barfing it's unlikely that your cluster is health.

  
