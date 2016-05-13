# CoCo Tutorial

## Goals and overview
By the time you finish this you will have deployed your own private CoCo cluster, figured out how to investigate problems and rectify them.

At a high level you will:
1. (#Setup SSH)

1. Create a repository and define two services to be run

1. Create a new CoCo cluster

1. Nurse it to health

1. Deploy a new service

1. Decommission the cluster

## Setup SSH
1. If you haven't already, generate a pair of SSH keys:
```bash
ssh-keygen
```

1. Edit your ssh config:
```bash
vi ~/.ssh/config
```

1. Add the following lines:
```
Host *tunnel-up.ft.com
  ForwardAgent yes
  User core
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
```

1. Add your SSH keys to the SSH agent:
```bash
ssh-add
```

  This needs to be done [every time the machine boots](http://unix.stackexchange.com/questions/140075/ssh-add-is-not-persistent-between-reboots), on OSX this problem can be avoided by adding them to OSX keychain:

  ```bash
  ssh-add -K
  ```

## Create a services repository

1. Create a public accessible repository. Probably the easiest way to do this is to create a public repo on [GitHub](https://github.com).

1. Create a service rosta

  You will need to create a `services.yml`, which will contain details of the services you want to run in the cluster.  Define one service by adding the following:

  ```yaml
  services:
  - name: my-app@.service
    count: 2
  ```

  In the UPP CoCo stack each service typically has a main `@.service` which contains details of the service and a second `-sidekick@.service` file which is used to monitor the service. For the purpose of this tutorial we'll just have the main service definition.

1. Create the service definitions

  All services run as systemd like entities through (fleet)[https://coreos.com/fleet/docs/latest/launching-containers-fleet.html].

  Create a file called `my-app@.service` and add the following

  ```
  [Unit]
  Description=MyApp
  After=docker.service
  Requires=docker.service

  [Service]
  TimeoutStartSec=0
  ExecStartPre=-/usr/bin/docker kill busybox1
  ExecStartPre=-/usr/bin/docker rm busybox1
  ExecStartPre=/usr/bin/docker pull busybox
  ExecStart=/usr/bin/docker run --name busybox1 busybox /bin/sh -c "trap 'exit 0' INT TERM; while true; do echo Hello World; sleep 3; done"
  ExecStop=/usr/bin/docker stop busybox1
  ```

  The `[Unit]` section lets you define dependencies, in this particular case we want to make sure docker is available before we try to use it!

  The `[Service]` section is the nuts and bolts of how you launch your service. Essentially the `ExecStartPre` get run before the main `ExecStart` and `ExecStop` runs when you want to stop the service.

###_[Service] in a bit more detail_

    You'll notice that in the `ExecStartPre` section we tidy up anything left over from a previously running instance of the server. The `ExecStartPre=-/usr/bin/docker kill busybox1` and `ExecStartPre=-/usr/bin/docker rm busybox1` kill the service if it is running and remove the container.

    Following this we get the latest 'busybox' docker image using `ExecStartPre=/usr/bin/docker pull busybox`.

    The service is finally launched via `ExecStart=/usr/bin/docker run --name busybox1 busybox /bin/sh -c "trap 'exit 0' INT TERM; while true; do echo Hello World; sleep 3; done"` which will simply print "Hello World" every three seconds unless it receives a term signal.

1. Commmit and push you recent additions

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
| SERVICES_DEFINITION_ROOT_URI | Service definitions
| TOKEN_URL | The etcd token identifying this cluster | ``curl https://discovery.etcd.io/new?size=5`` |
| AWS_MONITOR_TEST_UUID |  | `curl -s  https://www.uuidgenerator.net/api/version4` |
| COCO_MONITOR_TEST_UUID |  | ``curl -s  https://www.uuidgenerator.net/api/version4`` |


1. Run the provisioner

  You may need to run this as root, if this is the case `sudo` first
  ```bash
  docker run \
      --env "VAULT_PASS=$VAULT_PASS" \
      --env "TOKEN_URL=$TOKEN_URL" \
      --env "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
      --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
      --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
      --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" coco-provisioner
  ```

  There are some additional parameters which can be passed, however we won't need them for the moment since they configure CoCo's settings so it can access Kafka etc.

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

# Deploying your own UPP stack

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

## Keeping yourself up to date

You should periodically re-sync your private by issuing a `git rebase master` within your branch.

1. Checking the deployer

  The deployer, as it's name suggests, is responsible for deploying services to the cluster. If this is deploying or barfing it's unlikely that your cluster is health.

  1. SSH onto the cluster
  ```bash
  ssh $ENVIRONMENT_TAG-tunnel-up.ft.com
  ```

  1. Tail the deployer log
  ```bash
  ssh semantic-tunnel-up.ft.com fleetctl journal --lines=100 deployer
  ```

  1. All being well the deployer will just work, but it has been known to go a bit Pete Tong so do check it.

1. Checking the cluster's health

  1. Look at the health checks

  The system will take a little while to settle down. When it does there may be services in error, which will need some tlc and investigation.

  Fire up your favourite browser at your clusters HTTP/HTTPS endpoint, for example my cluster is called 'dgem' and only available through https, so the aggregate healthcheck endpoint would be:

  *https://dgem-up.ft.com/__health* (_double underscore_)

  *_You will be prompted for a username and password, which can be found in the Universal Publishing LastPass shared folder. Ask on the #co-co slack channel for access._*

  1. Start with the lowest common service that is failing and work your way up the stack. For example there is a known problem with mongodb, which means that you'll almost certainly have problems with it (at least until this get fixed).

1. Resuscitation of mongodb

  1. Checking it's state

    SSH into the cluster using the following:
    ```bash
    ssh $ENVIRONMENT_TAG-tunnel-up
    ```
