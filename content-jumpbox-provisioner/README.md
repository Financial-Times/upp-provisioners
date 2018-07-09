## Description
This repository contains the files required to provision a jumpbox to access the Content k8s clusters. The jumpbox has:
* `kubectl`, `kubectl-login` and `cluster-login.sh` installed, which is used to access the k8s clusters
* `docker`, which is used for PAC RDS failover

## Prerequisites
1. [Install docker](https://docs.docker.com/engine/installation/) locally

## Building the Docker image
The k8s provisioner can be built locally as a Docker image:

```
docker build -t content-jumpbox-provisioner:local .
```

##  Provisioning a new cluster

Here are the steps for provisioning a new cluster:

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a cluster. The variables are stored in LastPass: `upp-jumpbox provisioner`
1. Run the docker container that will provision the stack in AWS 
    ```
    docker run \
        -v $(pwd)/credentials:/ansible/credentials \
        -e "AWS_REGION=$AWS_REGION" \
        -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
        -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
        -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
        content-jumpbox-provisioner:local /bin/bash provision.sh
    ```    


