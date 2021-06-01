<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP - Ontotext Backup Aurora DB

Amazon Aurora PostgreSQL database used to store a backup of the Ontotext automatic suggestions.

## Code

upp-ontotext-backup-aurora

## Primary URL

https://github.com/Financial-Times/upp-provisioners/tree/master/upp-ontotext-backup-aurora-provisioner

## Service Tier

Bronze

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

<!-- Placeholder - remove HTML comment markers to activate
## Can Download Personal Data
Choose Yes or No

...or delete this placeholder if not applicable to this system
-->

<!-- Placeholder - remove HTML comment markers to activate
## Can Contact Individuals
Choose Yes or No

...or delete this placeholder if not applicable to this system
-->

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

<!-- Placeholder - remove HTML comment markers to activate
## Heroku Pipeline Name
Enter descriptive text satisfying the following:
This is the name of the Heroku pipeline for this system. If you don't have a pipeline, this is the name of the app in Heroku. A pipeline is a group of Heroku apps that share the same codebase where each app in a pipeline represents the different stages in a continuous delivery workflow, i.e. staging, production.

...or delete this placeholder if not applicable to this system
-->

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