# upp-rosette-classifier-provisioner

## Description

This repository contains the files required to provision a Rosette Classifier instance

1. [Install docker](https://docs.docker.com/engine/installation/) locally

## Building the Docker image

```
make rosette-classifier-provisioner
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

make rosette-classifier-instance

```

## Deleting the instance

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a Rosette Server. Get credentials for upp-rosette-provisioner user in PROD account and export them:

```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=
```

1. Run the following that will decommission the stack in AWS:

```

make destroy-rosette-classifier

```

## Usage

1. Connect to the instance:
Find the instance in AWS console (name ending at `*rosette-classifier`), take the IP address and ssh with:

```
ssh ec2-user@<IP of the instance>
```

The app is installed under `/classifier` folder. The folder is mounted on persistent EBS drive.
