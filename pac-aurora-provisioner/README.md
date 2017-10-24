# PAC Aurora Provisioning

The provisioning process will:

* Create a DB parameter group and DB cluster parameter group in eu-west-1 and us-east-1.
* Create DB subnet group in us-east-1.
* Creates a cluster in eu-west-1 using CloudFormation. This is formed of two DB instances in two local AZs.
* Creates a read replica cluster in us-east-1. This is also formed of two DB instances in two local AZs.
* Creates DNS entries via Konstructor for both regional clusters.

The decommissioning process will:

* Delete the DB parameter groups and cluster parameter groups in both regions.
* Delete the cluster in eu-west-1
* Deletes the Read Replica cluster in us-east-1
* Deletes the DNS entries via Konstructor in both regions.

## Building the Docker image

The PAC provisioner can be built locally as a Docker image:

`docker build -t pac-provisioner:local .`

## IMPORTANT: Check Configuration

Before proceeding with provisioning or decommissioning an Aurora cluster, please double check the Ansible vault configuration. To do that, first [install Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html) locally, then run the following:

```
# Environment Type can be 'p', 't' or 'd' depending on the type of cluster you will be working with.
export ENVIRONMENT_TYPE=p
ansible-vault edit ./ansible/vaults/vault_${ENVIRONMENT_TYPE}.yml
```

You will be prompted for a `Vault Password`, this can be found in the **pac-content-provisioner** LastPass note.

## Provisioning a cluster

- Get the environment variables from the **pac-content-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
- Set the `CLUSTER` environment variable, this be appended to `pac-aurora` for all the provisioned infrastructure. Note: The cluster name should be region agnostic, for example, `staging` will provision `pac-aurora-staging-eu` and `pac-aurora-staging-us` database instances.
- Run the following docker command

```
docker run \
    -e "CLUSTER=$CLUSTER" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    pac-provisioner:local /bin/bash provision.sh
```

Note that the process may take approximately an hour to provision fully.

## Decommissioning a cluster

- Get the environment variables from the **pac-content-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
- Run the following docker command

```
docker run \
    -e "CLUSTER=$CLUSTER" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    pac-provisioner:local /bin/bash decom.sh
```
