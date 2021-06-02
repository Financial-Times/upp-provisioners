# UPP Content Exporter S3 Provisioner

Provisions an Amazon S3 bucket in `eu-west-1` region used for storing full content exports.

For the available templates, please check the `config/cloudformation` folder.

## Provisioning a new Amazon S3 Bucket

```shell
make rebuild

# Fill in the AWS credentials created for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Fill in the desired environment (dev, staging, prod)
export ENVIRONMENT_NAME="dev"

make deploy
```

If you are actively changing the scripts or AWS CloudFormation templates
to make the build process faster you can use:

```sh
make rebuild-files
```

## Decommissioning the Amazon S3 Bucket

```shell
make rebuild

# Fill in the AWS credentials created for the "upp-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Fill in the desired environment (dev, staging, prod)
export ENVIRONMENT_NAME="dev"

make delete
```
