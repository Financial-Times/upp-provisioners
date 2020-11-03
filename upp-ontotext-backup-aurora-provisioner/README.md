# UPP Ontotext Backup RDS Provisioner

Provisions a Amazon RDS Aurora PostgreSQL DB single instance cluster to be used for Ontotext backup.

## Provisioning a new Amazon RDS Aurora PostgreSQL DB cluster

```sh
cd upp-ontotext-backup-aurora-provisioner

make rebuild

# Fill in the AWS credentials created for the "upp-rds-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Specify the DB password
export MASTER_PASSWORD=${MASTER_PASSWORD}" \

# Fill in the desired environment (dev, staging, prod)
export ENVIRONMENT_NAME="dev"

make deploy
```

If you are actively changing the scripts or AWS CloudFormation templates
to make the build process faster you can use:

```sh
make rebuild-files
```

## Decommissioning the Amazon RDS Aurora PostgreSQL DB cluster

```sh
cd upp-ontotext-backup-aurora-provisioner

make rebuild

# Fill in the AWS credentials created for the "upp-rds-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Fill in the desired environment (dev, staging, prod)
export ENVIRONMENT_NAME="dev"

make delete
```
