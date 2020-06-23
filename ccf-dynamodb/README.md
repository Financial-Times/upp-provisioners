# Copyright Cleared Feed DynamoDB Provisioner

Provisions DynamoDB table that will be used to store client settings for Copyright Cleared Feed.

## Provisioning new CCF DynamoDB table

```sh
cd ccf-dynamodb

make build-provisioner

# Fill in the AWS credentials and region e.g. us-east-1
# The credentials should be for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"
export AWS_REGION="us-east-1"

# Fill in the required details e.g. for staging environment
export ENVIRONMENT_NAME="staging"
export ENVIRONMENT_TYPE="t"

make provision-dynamodb
```

## Decommissioning CCF DynamoDB table

```sh
cd ccf-dynamodb

make build-provisioner

# Fill in the AWS credentials and region e.g. us-east-1
# The credentials should be for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"
export AWS_REGION="us-east-1"

# Fill in the required details e.g. for staging environment
export ENVIRONMENT_NAME="staging"

make decommission-dynamodb
```
