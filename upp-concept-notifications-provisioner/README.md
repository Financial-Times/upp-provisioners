# AWS Concept Notifications provisioner

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

The AWS Concept Notifications provisioning process will:

* Creates a kinesis stream in the target account named `upp-concept-notifications-${ENVIRONMENT_TAG}`. This stream will have notifications of concept updates posted to it from the aggregate-concept-transformer service running in UPP delivery clusters

* Next are currently the only consumer of this stream. Because they do not have a test environment there does not need to be streams for each environment. As a result there will be 2 streams per account(2x test & 2x prod) and all lower environments + staging will point to the test streams. To avoid duplication the aggregate-concept-transformers in eu & us need to point at different streams; the prod eu stream is the only one that will have any consumers.

## Building the Docker image
The Concept Notifications provisioner can be built locally as a Docker image:

`docker build -t coco/upp-concept-notifications-provisioner:local .`

## Provisioning a cluster
- Grab, customize and export the environment variables from the **AWS Concept Notifications provisioning** LastPass note.
- The stack name will be `upp-concept-notifications-stack-${ENVIRONMENT_TAG}` - eg, `upp-concept-publishing-dev`
- The environment tag length must be less than or equal to 28
- Generate credentials for the IAM user `upp-concept-pub-provisioner` in the InfraProd AWS account
- The cloudformation script expects four parameters:
  * Environment Tag - Which environment this belongs to. e.g test/prod
  * Environment Type - The level of instance. e.g d/t/p
  * AWS Access Key - Access key of the IAM user
  * AWS Secret Key - Secret Access key of the IAM user

- Run the following Docker commands:
```
docker pull coco/upp-concept-notifications-provisioner:latest

docker run \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    coco/upp-concept-notifications-provisioner:latest /bin/bash provision.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).

## Decommissioning a cluster
- Grab, customize and export the environment variables from the **AWS Concept Notifications provisioning** LastPass note.
- Generate credentials for the IAM user `upp-concept-pub-provisioner` in the InfraProd AWS account

Run the following Docker commands:
```
docker pull coco/upp-concept-notifications-provisioner:latest

docker run \
    -e "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \ 
    coco/upp-concept-notifications-provisioner:latest /bin/bash decom.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).
