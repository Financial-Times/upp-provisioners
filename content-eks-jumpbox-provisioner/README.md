## Description
This repository contains the files required to provision a jumpbox to access the Prod Content k8s clusters. The jumpbox has:
* `kubectl`, `kubectx` and connection to production kubernetes EKS clusters.
* the address of the jumpbox is `upp-jumpbox-p.upp.ft.com`

## Prerequisites
1. [Install docker](https://docs.docker.com/engine/installation/) locally

## Building the Docker image

```
make jumpbox-provisioner
```

##  Provisioning a new instance

Here are the steps for provisioning a new cluster:

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a cluster. Get credentials for upp-jenkins-provisioner user in PROD account and export them:
```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
```

1. Run the following that will provision the stack in AWS:

```

make prod-jumpbox

```

## Deleting the cluster

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a cluster. Get credentials for upp-jenkins-provisioner user in PROD account and export them:

```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
```

1. Run the following that will decommission the stack in AWS:

```

make destroy-prod-jumpbox

```

## Usage

Login to jumpbox and switch to ec2-user:

```

aws ssm start-session --target <instance_id>
sh-4.2$ sudo su - ec2-user
sh-4.2$ bash

```

Show list of available EKS clusters:

```
kubectx

```

Login to the desired cluster:

```
kubectx eks-delivery-prod-eu

```
