# upp-rosette-server-provisioner

## Description

This repository contains the files required to provision a Rosette Server - PROD and STAGING environment

## Prerequisites

1. [Install docker](https://docs.docker.com/engine/installation/) locally

## Building the Docker image

```
make rosette-server-provisioner
```

## Provisioning a new instance

Here are the steps for provisioning a new cluster:

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a Rosette Server. Get credentials for upp-rosette-provisioner user in PROD account and export them:
```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=
```

1. Run the following that will provision the stack in AWS:

```

make staging-rosette-server

```

## Deleting the cluster

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a Rosette Server. Get credentials for upp-rosette-provisioner user in PROD account and export them:

```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=
```

1. Run the following that will decommission the stack in AWS:

```

make destroy-staging-rosette-server

```

## Usage

The server exposes an Endpoint at `http://cm-rosette-t.upp.ft.com` (for Staging) or `http://cm-rosette-p.upp.ft.com` (for Prod) on default port `8181`. You need to be in VPN to access it.
You can ping the endpoint with:

```

curl http://cm-rosette-t.upp.ft.com:8181/rest/v1/ping | jq

```
Get current version:

```

curl http://cm-rosette-t.upp.ft.com:8181/rest/v1/info | jq

```

Test entities endpoint:

```

curl --request POST \
 --url http://cm-rosette-t.upp.ft.com:8181/rest/v1/entities \
 --header 'accept: application/json' \
 --header 'content-type: application/json' \
 --data '{"content": "Bill Murray will appear in new Ghostbusters film: Dr. Venkman was spotted filming in Boston"}'

 ```

Login to the instance with AD credentials
