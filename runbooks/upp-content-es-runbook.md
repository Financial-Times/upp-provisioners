# UPP - Content Elasticsearch Cluster

Elasticsearch cluster for use by the Content Search API Port service and Content-RW-Elasticsearch service. 

## Code

upp-content-es-cluster

## Service Tier

Platinum

## Lifecycle Stage

Production

## Delivered By

content

## Supported By

content

## Known About By

- hristo.georgiev
- robert.marinov
- elina.kaneva
- georgi.ivanov
- tsvetan.dimitrov
- dimitar.terziev
- donislav.belev
- mihail.mihaylov
- boyko.boykov

## Host Platform

AWS

## Architecture

There are two regional Amazon Elasticsearch clusters, one in eu-west-1 and one in us-east-1. Each regional cluster contains 4 data nodes and 3 dedicated master nodes.

## Contains Personal Data

No

## Contains Sensitive Data

No

## Failover Architecture Type

ActiveActive

## Failover Process Type

PartiallyAutomated

## Failback Process Type

PartiallyAutomated

## Failover Details

The service is part of both Delivery clusters. The failover guide for Delivery clusters can be found here: <https://github.com/Financial-Times/upp-docs/tree/master/failover-guides/delivery-cluster>

## Data Recovery Process Type

Manual

## Data Recovery Details

The procedure of creating and restoring from snapshots is described here: <https://github.com/Financial-Times/upp-provisioners/tree/master/upp-elasticsearch-provisioner#migrating-data-between-elasticsearch-clusters>

## Release Process Type

PartiallyAutomated

## Rollback Process Type

Manual

## Release Details

Manual failover is needed. For more details about the failover process please see: <https://github.com/Financial-Times/upp-docs/tree/master/failover-guides/delivery-cluster>

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-elasticsearch-provisioner" user credentials are used during provisioning only.

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>
