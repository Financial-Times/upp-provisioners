# AWS Concept Publishing provisioner

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

The AWS Concept Publishing provisioning process will:

* Create an S3 Bucket, SNS Topic and 1/2 SQS Queues using the specified Cloudformation Template which is used as a part of the event-driven concept publishing pipeline.

The decommissioning process will:

* Delete the S3 Bucket and its contents
* Delete the SNS Topic and the SQS queues


## Building the Docker image
The Concept Publishing provisioner can be built locally as a Docker image:

`docker build -t coco/upp-concept-publishing-provisioner:local .`

## Provisioning a cluster
- Grab, customize and export the environment variables from the **AWS Concept Publishing Provisioning** LastPass note.
- The stack name will be `upp-concept-publishing-${ENVIRONMENT_TAG}` - eg, `upp-concept-publishing-pre-prod`
- The environment tag length must be less than or equal to 28
- Generate credentials for the IAM user `upp-concept-publishing-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.
- The cloudformation script requires five parameters:
  * Environment Tag - Which environment this belongs to. e.g pre-prod
  * IsMultiRegion - Whether the stack needs to be read in multiple regions (will spin up 2 SQS queues rather than 1)
  * AwsSecondaryRegion - The region in which to deploy the second SQS queue
  * AWS Access Key - Access key of the IAM user
  * AWS Secret Key - Secret Access key of the IAM user
- Run the following Docker commands:
```
docker run \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "IS_MULTI_REGION=$IS_MULTI_REGION" \
    -e "AWS_SECONDARY_REGION=$AWS_SECONDARY_REGION" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "SQS_CONCEPT_MAX_DEPTH=$SQS_CONCEPT_MAX_DEPTH" \
    coco/upp-concept-publishing-provisioner:local /bin/bash provision.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).

## Decommissioning a cluster
- Grab, customize and export the environment variables from the **AWS Concept Publishing Provisioning** LastPass note.
- Generate credentials for the IAM user `upp-concept-publishing-provisioner` in `content-test` aws account for a dev stack or in `content-prod` aws account for a staging/ prod stack.
- - Run the following Docker commands:
```
docker run \
    -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "IS_MULTI_REGION=$IS_MULTI_REGION" \
    -e "AWS_SECONDARY_REGION=$AWS_SECONDARY_REGION" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "DECOM_DBS=$DECOM_DBS" \   
    coco/upp-concept-publishing-provisioner:local /bin/bash decom.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).
