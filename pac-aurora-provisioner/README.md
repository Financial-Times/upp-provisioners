# PAC Aurora Provisioning - manual steps

The provisioning process will:

* Creates a cluster in eu-west-1 using the cloudformation template
* Creates a read replica in us-east-1 using the aws cli. This will be updated with a cloudformation template

The decomissioning process will:

* Delete the Cluster in eu-west-1
* Deletes the Read Replica in us-east-1
* Deletes the db parameter and cluster parameter groups

## Building the Docker image

The PAC provisioner can be built locally as a Docker image:

`docker build -t pac-provisioner:local .`

## Provisioning a cluster

- Get the environment variables from the **User pac-content-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
- Run the following docker command

```
docker run \
    -e "CLUSTER=$CLUSTER" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    pac-provisioner:local /bin/bash provision.sh
```

Note that the `Creation of DB cluster` in EU and US may take upto 15 mins.

## Decommissioning a cluster

- Get the environment variables from the **User pac-content-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
- Run the following docker command

```
docker run \
    -e "CLUSTER=$CLUSTER" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    pac-provisioner:local /bin/bash decom.sh
```

## Things to do

* The creation of the read replica in US is done using AWS CLI, because cloudformation can't be used as the DBCluster type it uses to create a read replica is missing a parameter `ReplicationSourceIdentifier`. Feature request raised with AWS. Once that gets addressed, the provisioning of the read replica will be done using a cloudformation stack.

* Create DNS name for the cluster using konstructor using ansible