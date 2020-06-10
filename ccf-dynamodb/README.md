# Copyright Cleared Feed DynamoDB Provisioner

Provisions DynamoDB table that will be used to store client settings for Copyright Cleared Feed.

## Provisioning new CCF DynamoDB table

```sh
cd ccf-dynamodb

# Build the docker image
docker build -t ccf-dynamodb:local .

# Fill in the AWS credentials and region e.g. us-east-1
# The credentials should be for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"
export AWS_REGION="us-east-1"

# Fill in the required details e.g. for staging environment
export ENVIRONMENT_NAME="staging"
export ENVIRONMENT_TYPE="t"

docker run --rm -it \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_REGION=$AWS_REGION" \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    ccf-dynamodb:local /bin/bash provision.sh
```

## Decommissioning CCF DynamoDB table

```sh
cd ccf-dynamodb

# Build the docker image
docker build -t ccf-dynamodb:local .

# Fill in the AWS credentials and region e.g. us-east-1
# The credentials should be for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"
export AWS_REGION="us-east-1"

# Fill in the required details e.g. for staging environment
export ENVIRONMENT_NAME="staging"

docker run --rm -it \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "AWS_REGION=$AWS_REGION" \
    -e "ENVIRONMENT_NAME=$ENVIRONMENT_NAME" \
    ccf-dynamodb:local /bin/bash decom.sh
```
