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
1. Run the following that will provision the stack in AWS 
    ```
    docker run \
        -e "AWS_REGION=$AWS_REGION" \
        -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
        -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
        -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
        content-jumpbox-provisioner:local /bin/bash provision.sh
    ```    

Finally, there are steps that have to be manually done on the EC2 instance after the provisioning. They are detailed [here](README-manual_steps.md)

## Updating the cluster

You would want to update the cluster for one of the following reasons:

1. To update the version of kubectl, update the version in the [userdata](cloudformation/stack.yml) and run the following that will update the stack in AWS
    ```
    docker run \
        -e "AWS_REGION=$AWS_REGION" \
        -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
        -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
        -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
        content-jumpbox-provisioner:local /bin/bash update.sh
    ```   
1. To update the version of docker, terminate the instance. Since the instances are in an autoscaling group, new instances will be spun up with the latest version of docker available in the yum package manager.

1. To update changes to the script written by [DutyOps](https://github.com/Financial-Times/upp-dutyops-scripts)

Finally, there are steps that have to be manually done on the EC2 instance after the upgrade. They are detailed [here](README-manual_steps.md)

## Deleting the cluster

1. [Build your docker image locally](#building-the-docker-image)
1. Set the environment variables to provision a cluster. The variables are stored in LastPass: `upp-jumpbox provisioner`
1. Run the following that will decommission the stack in AWS 
    ```
    docker run \
        -e "AWS_REGION=$AWS_REGION" \
        -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
        -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
        -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
        content-jumpbox-provisioner:local /bin/bash decom.sh
    ```  
