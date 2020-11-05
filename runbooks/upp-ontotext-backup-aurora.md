# UPP - Ontotext Backup Aurora DB

Amazon Aurora PostgreSQL database used to store a backup of the Ontotext automatic suggestions.

## Code

upp-ontotext-backup-aurora

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/upp-ontotext-backup-aurora-provisioner>

## Service Tier

Bronze

## Lifecycle Stage

Production

## Delivered By

content

## Supported By

content

## Known About By

- elitsa.pavlova
- kalin.arsov
- ivan.nikolov
- dimitar.terziev
- mihail.mihaylov
- boyko.boykov

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

None

## Data Recovery Details

None

## Release Process Type

Manual

## Rollback Process Type

Manual

## Release Details

Follow the steps in the [UPP Ontotext Backup RDS Provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-ontotext-backup-aurora-provisioner/README.md).

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-rds-provisioner" user credentials are used during provisioning only.

## Monitoring

Check the RDS dashboard in the AWS console.

Additionally, the connectivity to the database is checked by the Concept Suggestion Writer Postgres service:
<https://upp-prod-delivery-eu.upp.ft.com/__health/__pods-health?service-name=concept-suggestion-writer-postgres>

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.
