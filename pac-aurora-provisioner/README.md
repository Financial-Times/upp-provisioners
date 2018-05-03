# PAC Aurora Provisioning

## Building the Docker image

The PAC provisioner can be built locally as a Docker image:

`docker build -t pac-provisioner:local .`

## Using latest stable verion of the PAC Aurora provisioning scripts

Everytime a new branch is merged in master, a new docker image with the latest stable version of the provisioning scripts 
is pushed in Docker Hub as a Docker image. To use the latest Docker image run:

`docker pull coco/pac-aurora-provisioner:latest`

## IMPORTANT: Check Configuration

Before proceeding with provisioning or decommissioning an Aurora cluster, please double check the Ansible vault configuration. To do that, first [install Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html) locally, then run the following:

```
# Environment Type can be 'p', 't' or 'd' depending on the type of cluster you will be working with.
export ENVIRONMENT_TYPE=p
ansible-vault edit ./ansible/vaults/vault_${ENVIRONMENT_TYPE}.yml
```

You will be prompted for a `Vault Password`, this can be found in the **pac-aurora-provisioner** LastPass note.

## IMPORTANT: DNS Configuration

PAC Aurora DNS configuration is shown [here](https://docs.google.com/drawings/d/1qhEvsPCkblwb4xBAG4RVxv-_s_Z3siGE1h3krabycEQ/edit). there is one level of indirection between the permanent GLB CNAME and the actual cluster GLB CNAME. This allows us to provision two clusters and flip the TOP Level DNS name between them as required (for DR)

This is important as in the provisioner script the CLUSTER (prod, staging) is passed in seperately from the CLUSTER_SUFFIX some of the scripts e.g. failover, decom, clean up the CLUSTER is the  full clustername e.g. prod-suffix.

## Provisioning a cluster with an empty database

The provisioning process will:

* Create a DB parameter group and DB cluster parameter group in eu-west-1 and us-east-1.
* Create DB subnet group in us-east-1.
* Creates a cluster in eu-west-1 using CloudFormation. This is formed of two DB instances in two local AZs.
* Creates a read replica cluster in us-east-1. This is also formed of two DB instances in two local AZs.
* Creates DNS entries via Konstructor for both regional clusters.

To provision a new PAC Aurora database cluster:

- Generate credentials for the IAM user `pac-content-provisioner` in content-test aws account for a dev stack or in content-prod aws account for a staging/ prod stack.
- Get the environment variables from the **pac-aurora-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
- Set the `CLUSTER` environment variable and the `CLUSTER_SUFFIX`, this will be appended to `pac-aurora` for all provisioned infrastructure. `CLUSTER_SUFFIX` will be appended to the environment name it is possible to provision a db without a suffix however for DR purposes you should always add a suffix (currently we are working off a list of composer name [here](https://docs.google.com/spreadsheets/d/1cyqrrC5T24EU3frwPtXe8xr3mrOPSNxxvSB88IDZsaE/edit#gid=0 "composer list")).
  Note: The cluster name should be region agnostic, for example, `staging-xxx` will provision `pac-aurora-staging-xxx-eu` and `pac-aurora-staging-xxx-us` database instances.
- Set the `CURRENT_RDATA_CNAME` this is the CNAME the top level GLB address is pointing to (e.g. staging-xxx-rds-pac.ft.com). you can find out what it is by  doing an nslookup or dig on the top level GLB address, e.g. nslookup prod.rds.pac.ft.com.
  See note above regarding DNS configuration.
- Set the `ENVIRONMENT_TYPE` environment variable to the type of environment the cluster will be, i.e. `t` for staging, `p` for production and `d` for anything else.
- Set the `PAC_DB_USER_PASSWORD` environment variable. The provisioner will create a `pac` user with appropriate permissions in the new database, which is identified by the provided the password.

NOTE: if there is a need a database can be provisioned without the `CLUSTER_SUFFIX` and `CURRENT_RDATA_CNAME` the script will support it. this will result in DNS set up of one leve GLB e.g. staging-rds-pac, staging-rds-eu-pac and staging-rds-us-pac.

- Run the following docker command

```
docker run \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CLUSTER=$CLUSTER" \
    -e "CLUSTER=$CLUSTER_SUFFIX" \
    -e "CURRENT_RDATA_CNAME=$CURRENT_RDATA_CNAME" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "PAC_DB_USER_PASSWORD=$PAC_DB_USER_PASSWORD" \
    pac-provisioner:local /bin/bash provision.sh
```

Note that the process may take approximately an hour to provision fully.

## Provisioning a cluster from an existing database snapshot

The provisioning process will reflect the same for provisioning a cluster with an empty database
except that the Aurora cluster in eu-west-1 will be created from an existing DB snapshot in AWS.
This implies that the restored snapshot will be propagated to the replica Aurora cluster in us-east-1 
region.   

To provision a new PAC Aurora database cluster:

- Generate credentials for the IAM user `pac-content-provisioner` in content-test aws account for a dev stack or in content-prod aws account for a staging/ prod stack.
- Get the environment variables from the **pac-aurora-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
- Set the `CLUSTER` environment variable and the `CLUSTER_SUFFIX`, this will be appended to `pac-aurora` for all provisioned infrastructure. `CLUSTER_SUFFIX` will be appended to the environment name it is possible to provision a db without a suffix however for DR purposes you should always add a suffix (currently we are working off a list of composer name [here](https://docs.google.com/spreadsheets/d/1cyqrrC5T24EU3frwPtXe8xr3mrOPSNxxvSB88IDZsaE/edit#gid=0 "composer list")).
  Note: The cluster name should be region agnostic, for example, `staging-xxx` will provision `pac-aurora-staging-xxx-eu` and `pac-aurora-staging-xxx-us` database instances.
- Set the `CURRENT_RDATA_CNAME` this is the CNAME the top level GLB address is pointing to (e.g. staging-xxx-rds-pac.ft.com). you can find out what it is by  doing an nslookup or dig on the top level GLB address, e.g. nslookup prod-rds-pac.ft.com
  See note above regarding DNS configuration.
- Set the `ENVIRONMENT_TYPE` environment variable to the type of environment the cluster will be, i.e. `t` for staging, `p` for production and `d` for anything else.
- Set the `SOURCE_SNAPSHOT` environment variable to specify from which DB snapshot you want to provision the cluster. The variable value is the ARN of the DB snapshot, which is available in the AWS console.

NOTE: if there is a need a database can be provisioned without the `CLUSTER_SUFFIX` and `CURRENT_RDATA_CNAME` the script will support it. this will result in DNS set up of one leve GLB e.g. staging-rds-pac, staging-rds-eu-pac and staging-rds-us-pac.

provision the cluster. The variable value is the ARN of the DB snapshot, which is available in 
the AWS console.

- Run the following docker command

```
docker run \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CLUSTER=$CLUSTER" \
    -e "CLUSTER_SUFFIX=$CLUSTER_SUFFIX" \
    -e "CURRENT_RDATA_CNAME=$CURRENT_RDATA_CNAME" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "SOURCE_SNAPSHOT=$SOURCE_SNAPSHOT" \
    pac-provisioner:local /bin/bash provision.sh
```

**NB:** 
* The cluster can be provisioned only in the same AWS account where the source snapshot has been created.
To use a DB snapshot from a different account you need to share the snapshot to the AWS account
in which you want to provision the new Aurora cluster. Details on sharing DB snapshots are available 
[here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ShareSnapshot.html).     
* `PAC_DB_USER_PASSWORD` variable is going to be ignored. 
The password for the PAC DB user is the one used by the DB of which the snapshot has been made.
* Note that the process may take approximately an hour and half to provision fully. 
This time have been measured on January 2018, based on a 1GB snapshot.

## Decommissioning a cluster

The decommissioning process will:

* Delete the DB parameter groups and cluster parameter groups in both regions.
* Delete the cluster in eu-west-1
* Deletes the Read Replica cluster in us-east-1
* Deletes the DNS entries via Konstructor in both regions.

To decommission a PAC Aurora database cluster:

* Generate credentials for the IAM user `pac-content-provisioner` in content-test aws account for a dev stack or in content-prod aws account for a staging/ prod stack.
* Get the environment variables from the **pac-aurora-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
* Set the `CLUSTER` environment variable to the cluster that you wish to decommission, i.e. `staging`.
* Set the `ENVIRONMENT_TYPE` environment variable to the type of environment the cluster is, i.e. `t` for staging, `p` for production and `d` for anything else.
* Run the following docker command

NOTE:- `CLUSTER` here is the full cluster name including a suffix if there is one. e.g. staging-bach

```
docker run \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CLUSTER=$CLUSTER" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    pac-provisioner:local /bin/bash decom.sh
```

## Automated Failover between two regions

The provisioner is also capable of failing over the Master database to a replica in another region. The failover will:

* Promote the replica to become a Master database, which severs replication from the previous Master.
* Remove Cloudwatch alarms from the previous Master database. This ensures that our monitoring is aware that the previous Master is no longer used.
* Updates the top level DNS via Konstructor to point to the new Master database.

To trigger the failover:

* Generate credentials for the IAM user `pac-content-provisioner` in content-test aws account for a dev stack or in content-prod aws account for a staging/ prod stack.
* Get the environment variables from the **pac-aurora-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
* Set the `CLUSTER` environment variable to the cluster that you wish to failover.  Failover is on the second level GLB (see DNS note above) therefore `CLUSTER` here is the full cluster name including a suffix if there is one. e.g. staging-bach
* Set the `ENVIRONMENT_TYPE` environment variable to type of environment the cluster is, i.e. `t` for staging, `p` for production and `d` for anything else.
* Determine which AWS region you are failing over **FROM** and which you are failing over **TO**. For example, if your faulty Master database is in `eu-west-1` and your healthy replica is in `us-east-1`, then you would set `FAILOVER_FROM_REGION=eu-west-1` and `FAILOVER_TO_REGION=us-east-1`.
* Run the following docker command:


NOTE:- `CLUSTER` here is the full cluster name including a suffix if there is one. e.g. staging-bach, you can check what this is by doing an nslookup or dig on the top level GLB address, e.g. nslookup prod-rds-pac.ft.com
See note above regarding DNS configuration.

```
docker run \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CLUSTER=$CLUSTER" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "FAILOVER_FROM_REGION=eu-west-1" \
    -e "FAILOVER_TO_REGION=us-east-1" \
    pac-provisioner:local /bin/bash failover.sh
```

## Automated Cleanup of the Failed Database

After the Master has been failed over to another region, we need to reestablish the resiliency of our database, and tidy up the now orphaned Master database. The following `failover-cleanup` script will:

* Decommission the existing orphaned Master database.
* Ensure that a valid RDS subnet group and parameter group are setup in that region.
* Create a new Replica database cluster.
* Recreate Cloudwatch alarms for the replica.

To trigger the failover cleanup:

* Generate credentials for the IAM user `pac-content-provisioner` in content-test aws account for a dev stack or in content-prod aws account for a staging/ prod stack.
* Get the environment variables from the **pac-aurora-provisioner** LastPass note in the **Shared-PAC Credentials & Services Login Details** folder.
* Set the `CLUSTER` environment variable to the cluster that you wish to failover, i.e. `staging-bach`.
* Set the `ENVIRONMENT_TYPE` environment variable to type of environment the cluster is, i.e. `t` for staging, `p` for production and `d` for anything else.
* Determine which AWS region you failed over **FROM** and which you failed over **TO**. For example, if your faulty Master database was in `eu-west-1` and your new healthy Master is in `us-east-1`, then you would set `FAILOVER_FROM_REGION=eu-west-1` and `FAILOVER_TO_REGION=us-east-1`.
* Run the following docker command:

NOTE:- `CLUSTER` here is the full cluster name including a suffix if there is one. e.g. staging-bach, you can check what this is by doing an nslookup or dig on the top level GLB address, e.g. nslookup prod-rds-pac.ft.com
See note above regarding DNS configuration.

```
docker run \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CLUSTER=$CLUSTER" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "FAILOVER_FROM_REGION=eu-west-1" \
    -e "FAILOVER_TO_REGION=us-east-1" \
    pac-provisioner:local /bin/bash failover-cleanup.sh
```
 
 
