# SQS Provisioner

Provisions SQS queues in TEST and PROD account.

## Provisioning all SQS queues in TEST account EU

```sh
cd upp-sqs-provisioner

make build-provisioner

# Fill in the AWS credentials
# The credentials should be for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"


make provision-sqs-testaccount-eu
```

## Delete all SQS in TEST account EU

```sh
cd upp-sqs-provisioner
make build-provisioner

# Fill in the AWS credentials and region e.g. us-east-1
# The credentials should be for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"


make remove-sqs-testaccount-eu
```

## Display help

```sh
make help

```
