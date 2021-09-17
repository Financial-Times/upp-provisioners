# UPP concept events RDS

The concept events pipeline consists of SQS queue and a deadletter queue in addition to the RDS database.

## Code

upp-concept-events-rds

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/upp-concept-events-pipeline-provisioner>

## Service Tier

Bronze

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

- SQS queue
- RDS Database

## Contains Personal Data

No

## Contains Sensitive Data

No

## Failover Architecture Type

None

## Failover Process Type

None

## Failback Process Type

None

## Failover Details

None

## Data Recovery Process Type

Manual

## Data Recovery Details

Use the comprehensive AWS step by step guide for restoring a DB instance from a DB snapshot:

https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.RestoringFromSnapshot.html

## Release Process Type

Manual

## Rollback Process Type

Manual

## Release Details

Follow the steps in the [README](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-concept-events-pipeline-provisioner/README.md#provisioning-a-cluster).

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-rds-provisioner" user credentials are used during provisioning only.

## Monitoring

Check the RDS dashboard in the AWS console.

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.
