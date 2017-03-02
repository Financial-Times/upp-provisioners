# Neo4j HA Cluster

Basic useful feature list:

 * Deploy cluster of 3 Neo4j nodes with 1 Read and 1 Write ALB
 * Deploy private subnets into an existing UPP VPC.

## Build 
The cluster provisioner can be built as a Docker image: \
`docker build -t coco/up-neo4j-cluster:latest .`

There is no build process for the subnets - the cloudformation scripts just need running 
via the console or the cli, depending on where you've got the right permissions.

## Provisioning a new cluster
- Grab, customise and run the environment variables from the *Neo4J Cluster - Provisioning Setup* LastPass note.
- Run the following Docker commands:
```
docker pull coco/up-neo4j-cluster:latest
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
    coco/up-neo4j-cluster:latest
```
- You can monitor the provisioning by going to the Cloudformation section in the AWS console and looking for the stack `up-neo4j-<ENVIRONMENT_TAG>`.


## Decommisioning a cluster
- Export the required environment variables.
- Run the following Docker command:
```
docker run \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    coco/up-neo4j-cluster:latest /bin/bash /decom.sh
```
- You can monitor the provisioning by going to the Cloudformation section in the AWS console and looking for the stack `up-neo4j-<ENVIRONMENT_TAG>`.

- If you've got the permissions, you can also delete the cloudformation stack directly from the AWS console.  Note, normal user permissions (ADFS-GeneralUserRole) is not enough - it can't delete the security groups.


## Deploying the private subnets
Deploying the private subnets should only need to be done once for the EU and US respectively.  If it needs to be redone, you can run the up-neo4j-private-subnets.yaml Cloudformation script with appropriate parameters.  Speak to one of your friendly integration engineers about how to get the right parameters.
