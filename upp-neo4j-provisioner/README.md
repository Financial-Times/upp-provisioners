# Neo4j HA Cluster

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

Basic useful feature list:

 * Deploy cluster of 3 Neo4j nodes with 1 Read and 1 Write ALB
 * Deploy private subnets into an existing UPP VPC.

## Build
The cluster provisioner can be built as a Docker image: \
`docker build -t coco/upp-neo4j-provisioner:latest .`

There is no build process for the subnets - the CloudFormation scripts just need running
via the console or the cli, depending on where you've got the right permissions.

## Creating a new cluster or updating an existing cluster
- Grab, customise and run the environment variables from the *Neo4J Cluster - Provisioning Setup* LastPass note.
- Note that your `ENVIRONMENT_TAG` **must** end with `-data`, otherwise the provisioner will abort.
- Run the following Docker commands:
```
docker pull coco/upp-neo4j-provisioner:latest
docker run \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
    -e "SPLUNK_HEC_URL=$SPLUNK_HEC_URL" \
    -e "SPLUNK_HEC_TOKEN=$SPLUNK_HEC_TOKEN" \
    -e "KONSTRUCTOR_API_KEY=$KONSTRUCTOR_API_KEY" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "TOKEN_URL=$TOKEN_URL" \
    -e "NEO_HEAP_SIZE=$NEO_HEAP_SIZE" \
    -e "NEO_CACHE_SIZE=$NEO_CACHE_SIZE" \
    coco/upp-neo4j-provisioner:latest
```
- If the cluster does not exist, the CloudFormation stack will be created.
- If the cluster already exists, then the CloudFormation stack will be updated with the latest configuration.
- You can monitor the provisioning by going to the CloudFormation section in the AWS console and looking for the stack `upp-<ENVIRONMENT_TAG>`.

### Reprovisioning prod & pre-prod clusters

Reprovisioning prod or pre-prod clusters will break the CloudWatch dashboards, as they will continue to pull metrics for the old (decommissioned) clusters.

After reprovisioning, you will need to update the dashboards to point at the new metrics.

The dashboards are located here:
- [prod-uk-data](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#dashboards:name=com-ft-up-prod-uk-neo4j)
- [prod-us-data](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#dashboards:name=com-ft-up-prod-us-neo4j)
- [pre-prod-uk-data](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#dashboards:name=com-ft-up-pre-prod-uk-data-neo4j)
- [pre-prod-us-data](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#dashboards:name=com-ft-up-pre-prod-us-data-neo4j)

## Attaching a delivery cluster to Neo4j
- Once your Neo4j cluster is online and accessible, you will need to set two etcd keys in the delivery cluster.
  - `/ft/config/neo4j/read_write_url` - set this to the write ALB URL
  - `/ft/config/neo4j/read_only_url` - set this to the read-only ALB URL
- Example for Pre-Prod UK:
```
etcdctl set /ft/config/neo4j/read_write_url http://upp-pre-prod-uk-data-write-alb-up.ft.com:7474/db/data/
etcdctl set /ft/config/neo4j/read_only_url http://upp-pre-prod-uk-data-read-alb-up.ft.com:7474/db/data/
```
- The `*-rw-neo4j` and `public-*` services need to be restarted to pick up the new URLs. Run the following shell snippet on the delivery cluster:
```
for service in `fleetctl list-units | grep -e -rw-neo4j@ -e public- -e relations-api | grep -v sidekick | cut -f 1` ; do
    echo "Restarting ${service}"
    fleetctl ssh ${service} sudo systemctl restart ${service}
done
```

## Decommisioning a cluster
- Export the required environment variables.
- Run the following Docker command:
```
docker pull coco/upp-neo4j-provisioner:latest
docker run -it \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "KONSTRUCTOR_API_KEY=$KONSTRUCTOR_API_KEY" \
    coco/upp-neo4j-provisioner:latest /bin/bash /decom.sh
```
- You can monitor the decommissioning by going to the Cloudformation section in the AWS console and looking for the stack `up-neo4j-<ENVIRONMENT_TAG>`.

## Deploying the private subnets
Deploying the private subnets should only need to be done once for the EU and US respectively.  If it needs to be redone, you can run the up-neo4j-private-subnets.yaml Cloudformation script with appropriate parameters.  Speak to one of your friendly integration engineers about how to get the right parameters.
