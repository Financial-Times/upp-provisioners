<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP - Content Elasticsearch Cluster

Elasticsearch cluster for use by the Content Search API Port service and Content-RW-Elasticsearch service.

## Code

upp-content-es-cluster

## Primary URL

<https://search-upp-sapi-v2-prod-eu-sfu6rx4tvpoiosezjaibejkvya.eu-west-1.es.amazonaws.com/>

## Service Tier

Platinum

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

There are two regional Amazon Elasticsearch clusters, one in eu-west-1 and one in us-east-1. Each regional cluster contains 4 data nodes and 3 dedicated master nodes.

[Content Delivery Diagram](https://lucid.app/lucidchart/5f4f1a8b-2d62-4fb3-a605-b54d52ba7ddb/edit?invitationId=inv_2d591f1a-d6df-4d98-8c33-3b74c4feaa37&page=X1hEm.AnbKcP#)

## Contains Personal Data

No

## Contains Sensitive Data

No

## Can Download Personal Data

No

## Can Contact Individuals
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

## Monitoring

Monitoring can be performed using the listed CloudWatch metrics below.

Content ElasticSearch EU:
- [Document Statistics](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~title~'Document*20Statistics~metrics~(~(~'AWS*2fES~'SearchableDocuments~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'DeletedDocuments~'.~'.~'.~'.))~start~'-PT24H~end~'P0D);query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [Cluster Health](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~metrics~(~(~'AWS*2fES~'ClusterStatus.yellow~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'ClusterStatus.red~'.~'.~'.~'.)~(~'.~'ClusterStatus.green~'.~'.~'.~'.)~(~'.~'Nodes~'.~'.~'.~'.)~(~'.~'MasterReachableFromNode~'.~'.~'.~'.))~title~'Cluster*20Health);query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [CPU Utilization](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~title~'CPU*20Utilization~start~'-PT12H~end~'P0D~metrics~(~(~'AWS*2fES~'MasterCPUUtilization~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'CPUUtilization~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [JVM Memory Pressure](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~title~'JVM*20Memory*20Pressure~start~'-PT12H~end~'P0D~metrics~(~(~'AWS*2fES~'JVMMemoryPressure~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'MasterJVMMemoryPressure~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [Disk Utilization](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~title~'Disk*20Utilization~start~'-PT24H~end~'P0D~metrics~(~(~'AWS*2fES~'FreeStorageSpace~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'MasterFreeStorageSpace~'.~'.~'.~'.)~(~'.~'ClusterUsedSpace~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [ReadWrite Latency](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~title~'Latency~start~'-PT3H~end~'P0D~metrics~(~(~'AWS*2fES~'WriteLatency~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'ReadLatency~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [ReadWrite Throughput](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~title~'Throughput~start~'-PT3H~end~'P0D~metrics~(~(~'AWS*2fES~'WriteThroughput~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'ReadThroughput~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [ReadWrite IOPS](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'eu-west-1~title~'IOPS~start~'-PT3H~end~'P0D~metrics~(~(~'AWS*2fES~'ReadIOPS~'DomainName~'upp-sapi-v2-prod-eu~'ClientId~'469211898354)~(~'.~'WriteIOPS~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)

Content ElasticSearch US:
- [Document Statistics](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~title~'Document*20Statistics~metrics~(~(~'AWS*2fES~'SearchableDocuments~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'DeletedDocuments~'.~'.~'.~'.))~start~'-PT24H~end~'P0D);query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [Cluster Health](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~metrics~(~(~'AWS*2fES~'ClusterStatus.yellow~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'ClusterStatus.red~'.~'.~'.~'.)~(~'.~'ClusterStatus.green~'.~'.~'.~'.)~(~'.~'Nodes~'.~'.~'.~'.)~(~'.~'MasterReachableFromNode~'.~'.~'.~'.))~title~'Cluster*20Health);query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [CPU Utilization](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~title~'CPU*20Utilization~start~'-PT12H~end~'P0D~metrics~(~(~'AWS*2fES~'MasterCPUUtilization~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'CPUUtilization~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [JVM Memory Pressure](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~title~'JVM*20Memory*20Pressure~start~'-PT12H~end~'P0D~metrics~(~(~'AWS*2fES~'JVMMemoryPressure~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'MasterJVMMemoryPressure~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [Disk Utilization](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~title~'Disk*20Utilization~start~'-PT24H~end~'P0D~metrics~(~(~'AWS*2fES~'FreeStorageSpace~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'MasterFreeStorageSpace~'.~'.~'.~'.)~(~'.~'ClusterUsedSpace~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [ReadWrite Latency](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~title~'Latency~start~'-PT3H~end~'P0D~metrics~(~(~'AWS*2fES~'WriteLatency~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'ReadLatency~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [ReadWrite Throughput](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~title~'Throughput~start~'-PT3H~end~'P0D~metrics~(~(~'AWS*2fES~'WriteThroughput~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'ReadThroughput~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)
- [ReadWrite IOPS](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~(view~'timeSeries~stacked~false~region~'us-east-1~title~'IOPS~start~'-PT3H~end~'P0D~metrics~(~(~'AWS*2fES~'ReadIOPS~'DomainName~'upp-sapi-v2-prod-us~'ClientId~'469211898354)~(~'.~'WriteIOPS~'.~'.~'.~'.)));query=~'*7bAWS*2fES*2cClientId*2cDomainName*7d)

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.
