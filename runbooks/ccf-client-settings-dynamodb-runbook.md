<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# CCF Client Settings DynamoDB

DynamoDB table that contains CCF licences and feeds.

## Code

ccf-client-settings-dynamodb

## Primary URL

https://github.com/Financial-Times/upp-provisioners/tree/master/ccf-dynamodb

## Service Tier

Bronze

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

There is a single DynamoDB table provisioned in N. Virginia (us-east-1) region.

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

Follow the steps in the [Copyright Cleared Feed DynamoDB Provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/ccf-dynamodb/README.md) to provision the DynamoDB table.

<!-- Placeholder - remove HTML comment markers to activate
## Heroku Pipeline Name
Enter descriptive text satisfying the following:
This is the name of the Heroku pipeline for this system. If you don't have a pipeline, this is the name of the app in Heroku. A pipeline is a group of Heroku apps that share the same codebase where each app in a pipeline represents the different stages in a continuous delivery workflow, i.e. staging, production.

...or delete this placeholder if not applicable to this system
-->

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM `upp-provisioner` user credentials are used during provisioning only.

## Monitoring

NotApplicable

## First Line Troubleshooting

Check the DynamoDB dashboard with the AWS console.
<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.