<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP - CCF Content ElasticSearch Cluster

ElasticSearch cluster for use by the CCF platform. Has content of type articles indexed. It's indexed by ccf-content-rw-elasticsearch and used by combined-content-search.

## Code

upp-ccf-content-es-cluster

## Primary URL

https://github.com/Financial-Times/upp-provisioners

## Service Tier

Bronze

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

There is one Amazon Elasticsearch clusters in us-east-1. The cluster contains 3 data nodes and 3 dedicated master nodes.

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

The service is only part of US Delivery clusters.

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

<!-- Placeholder - remove HTML comment markers to activate
## Heroku Pipeline Name
Enter descriptive text satisfying the following:
This is the name of the Heroku pipeline for this system. If you don't have a pipeline, this is the name of the app in Heroku. A pipeline is a group of Heroku apps that share the same codebase where each app in a pipeline represents the different stages in a continuous delivery workflow, i.e. staging, production.

...or delete this placeholder if not applicable to this system
-->

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-elasticsearch-provisioner" user credentials are used during provisioning only.

## Monitoring

AWS Cloudwatch

## First Line Troubleshooting

Check the AWS console, us-east-1 region for details about the ElasticSearch cluster health.
<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Check the "Migrating data between ElasticSearch clusters" section from the provisioner's <https://github.com/Financial-Times/upp-provisioners/blob/master/upp-elasticsearch-provisioner/README.md>.