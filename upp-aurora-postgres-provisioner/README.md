# UPP Aurora Postgres RDS Provisioner

Provisions an Amazon RDS Aurora PostgreSQL DB single instance cluster in `eu-west-1` region.
The database name and intent is determined by the environment variable `CF_TEMPLATE`. The available values are:
- `enriched-content-rds`

For the available templates, please check the `config/cloudformation` folder.

## Provisioning a new Amazon RDS Aurora PostgreSQL DB cluster

```sh
cd upp-aurora-postgres-provisioner

make rebuild

# Fill in the AWS credentials created for the "upp-rds-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Fill in the CloudFormation template name that you want to use
export CF_TEMPLATE="xxx"

# Fill in the database name that you want to use
export DB_NAME="xxx"

# Specify the DB password
export MASTER_PASSWORD="xxx"

# Fill in the desired environment (dev, staging, prod)
export ENVIRONMENT_NAME="dev"

# Specify the region (eu, us)
export REGION="eu"

make deploy
```

If you are actively changing the scripts or AWS CloudFormation templates
to make the build process faster you can use:

```sh
make rebuild-files
```

## Decommissioning the Amazon RDS Aurora PostgreSQL DB cluster

```sh
cd upp-aurora-postgres-provisioner

make rebuild

# Fill in the AWS credentials created for the "upp-rds-provisioner" user
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"

# Fill in the CloudFormation template name that you want to use
export CF_TEMPLATE="xxx"

# Fill in the desired environment (dev, staging, prod)
export ENVIRONMENT_NAME="dev"

# Specify the region (eu, us)
export REGION="eu"

make delete
```
