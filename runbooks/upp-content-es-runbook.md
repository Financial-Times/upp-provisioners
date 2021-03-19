<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP - Content Elasticsearch Cluster

Elasticsearch cluster for use by the Content Search API Port service and Content-RW-Elasticsearch service.

## Code

upp-content-es-cluster

<!-- Placeholder - remove HTML comment markers to activate
## Primary URL
Enter descriptive text satisfying the following:
The main url served by the system.

...or delete this placeholder if not applicable to this system
-->

## Service Tier

Platinum

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

There are two regional Amazon Elasticsearch clusters, one in eu-west-1 and one in us-east-1. Each regional cluster contains 4 data nodes and 3 dedicated master nodes.

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

<p><a href="https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~metrics~(~(~'AWS*2fES~'Nodes~'DomainName~'upp-sapi-v1-prod-eu~'ClientId~'469211898354)~(~'.~'FreeStorageSpace~'.~'.~'.~'.)~(~'.~'JVMMemoryPressure~'.~'.~'.~'.)~(~'.~'ReadIOPS~'.~'.~'.~'.)~(~'.~'WriteLatency~'.~'.~'.~'.)~(~'.~'ReadLatency~'.~'.~'.~'.)~(~'.~'DiskQueueDepth~'.~'.~'.~'.)~(~'.~'ReadThroughput~'.~'.~'.~'.)~(~'.~'CPUUtilization~'.~'.~'.~'.)~(~'.~'WriteIOPS~'.~'.~'.~'.)~(~'.~'SearchableDocuments~'.~'.~'.~'.)~(~'.~'MasterCPUUtilization~'.~'.~'.~'.)~(~'.~'DeletedDocuments~'.~'.~'.~'.)~(~'.~'ClusterUsedSpace~'.~'.~'.~'.)~(~'.~'AutomatedSnapshotFailure~'.~'.~'.~'.)~(~'.~'MasterReachableFromNode~'.~'.~'.~'.)~(~'.~'ClusterStatus.green~'.~'.~'.~'.)~(~'.~'ClusterStatus.yellow~'.~'.~'.~'.)~(~'.~'ClusterStatus.red~'.~'.~'.~'.)~(~'.~'MasterFreeStorageSpace~'.~'.~'.~'.)~(~'.~'MasterJVMMemoryPressure~'.~'.~'.~'.)~(~'.~'ClusterIndexWritesBlocked~'.~'.~'.~'.)~(~'.~'WriteThroughput~'.~'.~'.~'.))~region~'eu-west-1);namespace=AWS/ES;dimensions=ClientId,DomainName" target="_blank">Cloudwatch metrics (please select appropiate region, metrics)</a></p>

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

<!-- Placeholder - remove HTML comment markers to activate
## Second Line Troubleshooting
Enter descriptive text satisfying the following:
Troubleshooting information for members of the system's support or delivery team.

...or delete this placeholder if not applicable to this system
-->