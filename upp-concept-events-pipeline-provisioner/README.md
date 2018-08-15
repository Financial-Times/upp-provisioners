# AWS Concept Events Pipeline provisioner

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

The AWS Concept Events Pipeline provisioning process will:

* Create an SQS queue, as well as a deadletter queue.
* Create an RDS database.

The decommissioning process will:

* Delete the SQS queues.
* Delete the RDS database.

## Building the Docker image
The Concept Events Pipeline can be built locally as a Docker image:

``docker build -t coco/upp-concept-events-pipeline-provisioner:local .``

## Provisioning a cluster
- Grab, customize and export the environment variables from the **AWS Concept Events Pipeline Provisioning** LastPass note.
- The stack name will be `upp-concept-events-${ENVIRONMENT_NAME}` - eg, `upp-concept-events-pre-prod`
- The environment tag length must be less than or equal to 28
- Generate credentials for the IAM user `upp-concept-events-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.
- The cloudformation script requires five parameters:
  * Environment Tag - Which environment this belongs to. e.g pre-prod
  * AWS Access Key - Access key of the IAM user
  * AWS Secret Key - Secret Access key of the IAM user
- Run the following Docker commands:
```
docker pull coco/upp-concept-events-pipeline-provisioner:latest

docker run \
    -e "MASTER_PASSWORD=$MASTER_PASSWORD" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "SQS_CONCEPT_MAX_DEPTH=$SQS_CONCEPT_MAX_DEPTH" \
    coco/upp-concept-events-pipeline-provisioner:latest /bin/bash provision.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).

## Decommissioning a cluster
- Grab, customize and export the environment variables from the **AWS Concept Events Pipeline Provisioning** LastPass note.
- Generate credentials for the IAM user `upp-concept-events-pipeline-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.
- - Run the following Docker commands:
```
docker pull coco/upp-concept-events-pipeline-provisioner:latest

docker run \
    -e "MASTER_PASSWORD=$MASTER_PASSWORD" \
    -e "VAULT_PASS=$VAULT_PASS" \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    coco/upp-concept-events-pipeline-provisioner:latest /bin/bash decom.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).
