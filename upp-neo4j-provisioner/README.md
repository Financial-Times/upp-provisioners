# Neo4j HA Cluster

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

Basic useful feature list:

 * Deploy cluster of 3 Neo4j nodes with 1 Read and 1 Write ALB
 * Deploy private subnets into an existing UPP VPC.

## Build
The cluster provisioner can be built as a Docker image: \
`docker build -t coco/upp-neo4j-provisioner:latest .`

There is no build process for the subnets - the cloudformation scripts just need running
via the console or the cli, depending on where you've got the right permissions.

## Provisioning a new cluster
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
    -e "NEO_EXTRA_CONF_URL=$NEO_EXTRA_CONF_URL" \
    -e "TOKEN_URL=$TOKEN_URL" \
    -e "NEO_HEAP_SIZE=$NEO_HEAP_SIZE" \
    -e "NEO_CACHE_SIZE=$NEO_CACHE_SIZE" \
    coco/upp-neo4j-provisioner:latest
```
- You can monitor the provisioning by going to the Cloudformation section in the AWS console and looking for the stack `up-neo4j-<ENVIRONMENT_TAG>`.

## Attaching a delivery cluster to Neo4j
- Once your Neo4j cluster is online and accessible, you will need to set two etcd keys in the delivery cluster.
  - `/ft/config/neo4j/read_write_url` - set this to the write ALB URL
  - `/ft/config/neo4j/read_only_url` - set this to the read-only ALB URL
- Example for Pre-Prod UK:
```
etcdctl set /ft/config/neo4j/read_write_url http://upp-pre-prod-uk-data-write-alb-up.ft.com/db/data/
etcdctl set /ft/config/neo4j/read_only_url http://upp-pre-prod-uk-data-read-alb-up.ft.com/db/data/
```
- The `*-rw-neo4j` and `public-*` services need to be restarted to pick up the new URLs. Run the following shell snippet on the delivery cluster:
```
for service in `fleetctl list-units | grep -e -rw-neo4j@ -e public- | grep -v sidekick | cut -f 1` ; do
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
- You can monitor the provisioning by going to the Cloudformation section in the AWS console and looking for the stack `up-neo4j-<ENVIRONMENT_TAG>`.

- If you've got the permissions, you can also delete the cloudformation stack directly from the AWS console.  Note, normal user permissions (ADFS-GeneralUserRole) is not enough - it can't delete the security groups.


## Updating a cloudformation stack
- Export the required environment variables.
- Run the following Docker command:
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
    -e "NEO_EXTRA_CONF_URL=$NEO_EXTRA_CONF_URL" \
    -e "TOKEN_URL=$TOKEN_URL" \
    coco/upp-neo4j-provisioner:latest /bin/bash update.sh
```
- You can monitor the updation of the stack by going to the Cloudformation section in the AWS console and looking for the stack `up-neo4j-<ENVIRONMENT_TAG>`.
- The updation of the stack gets the latest ami, creates a new launch config with the new ami, deletes the old launch config and attaches the new launch config to the autoscaling group for the stack `up-neo4j-<ENVIRONMENT_TAG>`.

## Deploying the private subnets
Deploying the private subnets should only need to be done once for the EU and US respectively.  If it needs to be redone, you can run the up-neo4j-private-subnets.yaml Cloudformation script with appropriate parameters.  Speak to one of your friendly integration engineers about how to get the right parameters.
