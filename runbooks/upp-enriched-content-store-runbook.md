# UPP Enriched Content Store

Amazon Aurora PostgreSQL database storing FT content in a format close to the content representation in Enriched Content API.

## Code

upp-enriched-content-store

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/upp-aurora-postgres-provisioner>

## Service Tier

Gold

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

A single instance Aurora PostgreSQL database is provisioned in the Ireland (eu-west-1) region.

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

Follow the steps in the [UPP Aurora Postgres Provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-aurora-postgres-provisioner/README.md).

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
