# UPP RDS

The RDS provisioner will:

* Create a RDS instance using the specified Cloudformation template
* Create or update an appropriate CNAME record for the instance
* Load the database with factset data using [upp-rds-loader](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-rds-provisioner/loader) tool

The decommissioning process will:

* Delete the cloudformation stack based on the CLUSTER tag; which deletes the resources created by the stack
* Delete the instance CNAME record


## Building the Docker image
The RDS provisioner can be built locally as a Docker image:

`docker build -t coco/upp-rds-provisioner:local .`

Automated DockerHub builds are also triggered on new releases, located [here](https://hub.docker.com/r/coco/upp-rds-provisioner/).


## Provisioning a cluster
- Grab, customise and run the environment variables from the *AWS RDS Factset - Provisioning Setup* LastPass note.
- Run the following Docker commands:
```
docker pull coco/upp-rds-provisioner:latest
docker run \
    -e "CLUSTER=$CLUSTER" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "CLUSTER_SG=$CLUSTER_SG" \
    coco/upp-rds-provisioner:latest
```


## Connecting to the RDS instance

If you need to connect up the RDS instance, you need to create an `ssh` tunnel forwarding your connection. So you need to run:

```
ssh -A -L 5432:<CLUSTER>-factset-rds-up.in.ft.com:5432 core@<CLUSTER>-tunnel-up.ft.com
```

Then you can connect your Postgres client to `localhost:5432`. Example:

```
psql -h localhost -p 5432 -U <DB_USERNAME> Factset
```

An alternative to using `psql` is to use [pgAdmin](https://www.pgadmin.org/).


## Decommisioning a cluster
- Export the required environment variables.
- Run the following Docker command:
```
docker pull coco/upp-rds-provisioner:latest
docker run \
    -e "CLUSTER=$CLUSTER" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "VAULT_PASS=$VAULT_PASS" \
    coco/upp-rds-provisioner:latest decom.sh
```
- `Delete RDS cluster` step may take up to 5 minutes, as CloudFormation waits until the RDS instance is fully decommissioned before returning a success code.
- You can monitor the provisioning by going to the Cloudformation section in the AWS console and looking for the stack `upp-<CLUSTER>-factset-rds`.


## Todo
* Move this into repo for all our infrastructure
* Add cloudwatch alarms
* Implement lower environment teardown over weekends and recreate on mondays
