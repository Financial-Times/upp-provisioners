<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP - Content Fluentd Kinesis Stream

Kinesis stream which will process logs from the Content fluentd instance running within an UPP/PAC Kubernetes cluster.

## Code

content-fluentd-stream

## Primary URL

NotApplicable

## Service Tier

Bronze

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

The Kinesis stream has 1 shard and 24h retention period.

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

NotApplicable

## Failover Process Type

NotApplicable

## Failback Process Type

NotApplicable

## Failover Details

NotApplicable

## Data Recovery Process Type

NotApplicable

## Data Recovery Details

AWS guarantees for the data for the 24h retention period set.

## Release Process Type

Manual

## Rollback Process Type

Manual

## Release Details

Follow the steps in the [Content Fluentd Kinesis Provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/content-fluentd-kinesis/README.md) to provision it.

<!-- Placeholder - remove HTML comment markers to activate
## Heroku Pipeline Name
Enter descriptive text satisfying the following:
This is the name of the Heroku pipeline for this system. If you don't have a pipeline, this is the name of the app in Heroku. A pipeline is a group of Heroku apps that share the same codebase where each app in a pipeline represents the different stages in a continuous delivery workflow, i.e. staging, production.

...or delete this placeholder if not applicable to this system
-->

## Key Management Process Type

Manual

## Key Management Details

There is dedicated AWS IAM User `content-fluentd-kinesis-provisioner` which credentials should be created upon provisioning.

## Monitoring

NotApplicable

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.