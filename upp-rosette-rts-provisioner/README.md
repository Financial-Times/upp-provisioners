# upp-rosette-rts-provisioner

## Description

This repository contains the files required to provision a Rosette RTS - PROD and STAGING environment

## Prerequisites

1. [Install docker](https://docs.docker.com/engine/installation/) locally

## Building the Docker image

```
make rosette-rts-provisioner
```

## Provisioning a new instance

Here are the steps for provisioning a new instance:

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a Rosette RTS. Get credentials for upp-rosette-provisioner user in PROD account and export them:
```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=
```

1. Run the following that will provision the stack in AWS:

```

make staging-rosette-rts

```

## Deleting the cluster

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a Rosette RTS. Get credentials for upp-rosette-provisioner user in PROD account and export them:

```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=
```

1. Run the following that will decommission the stack in AWS:

```

make destroy-staging-rosette-rts

```

## Usage

