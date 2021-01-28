# UPP - Concept Elasticsearch Cluster

Elasticsearch cluster used for concept search in UPP hosted in AWS

## Primary URL

<https://github.com/Financial-Times/upp-provisioners>

## Code

concept-elasticsearch-cluster

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
- miroslav.gatsanoga
- dimitar.terziev
- hristo.georgiev

## Host Platform

AWS

## Architecture

Elasticsearch cluster used for concept search in UPP hosted in AWS

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

It is a AWS managed service.

## Data Recovery Process Type

Manual

## Data Recovery Details

The procedure of creating and restoring from snapshots is described here: <https://github.com/Financial-Times/upp-provisioners/tree/master/upp-elasticsearch-provisioner#migrating-data-between-elasticsearch-clusters>

## Release Process Type

PartiallyAutomated

## Rollback Process Type

Manual

## Release Details

A new version of the cluster can be created by provisioning it, please follow the provisioner's <https://github.com/Financial-Times/upp-provisioners/blob/master/upp-elasticsearch-provisioner/README.md>.

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-elasticsearch-provisioner" user credentials are used during provisioning only.

## Monitoring

AWS Cloudwatch

## First Line Troubleshooting

Check the AWS console for details about the ElasticSearch cluster health.
<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Check the "Migrating data between ElasticSearch clusters" section from the provisioner's <https://github.com/Financial-Times/upp-provisioners/blob/master/upp-elasticsearch-provisioner/README.md>.
