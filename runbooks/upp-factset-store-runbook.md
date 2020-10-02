# UPP Factset Store

Amazon Aurora MySQL DB cluster used to store Factset data.

## Code

upp-factset-store

## Primary URL

https://github.com/Financial-Times/upp-provisioners/tree/master/upp-factset-provisioner

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
- marina.chompalova
- miroslav.gatsanoga
- donislav.belev
- mihail.mihaylov
- boyko.boykov

## Host Platform

AWS

## Architecture

The UPP Factset Store is an Amazon Aurora MySQL RDS cluster of 1 database writer instance provisioned in the AWS Ireland (eu-west-1) region.

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

The UPP Factset Aurora MySQL has a configured point in time snapshot with 1 day retention period that serves as a backup. The database can be manually restored using the latest snapshot.

## Release Process Type

Manual

## Rollback Process Type

Manual

## Release Details

For release details check:
https://github.com/Financial-Times/upp-provisioners/blob/master/upp-factset-provisioner/README.md

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-factset-provisioner" user credentials are used during provisioning only.

## Monitoring

NotApplicable

## First Line Troubleshooting

Check the Amazon RDS dashboard with the AWS console.
https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.
