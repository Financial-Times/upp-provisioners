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

## Delivered By

content

## Supported By

content

## Known About By

- elitsa.pavlova
- kalin.arsov
- miroslav.gatsanoga
- ivan.nikolov
- marina.chompalova
- mihail.mihaylov
- boyko.boykov
- donislav.belev
- dimitar.terziev

## Host Platform

AWS

## Architecture

The Kinesis stream has 1 shard and 24h retention period.

## Contains Personal Data

No

## Contains Sensitive Data

No

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
