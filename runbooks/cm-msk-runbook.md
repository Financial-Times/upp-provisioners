# CM MSK

Provides operational guidance for managing a unified MSK (Managed Streaming for Apache Kafka) infrastructure that consolidates multiple Kafka clusters across regions.

## Code

cm-msk

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/upp-msk-provisioner>

## Service Tier

Platinum

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

A combined runbook containing all production MSK clusters we own.

## Contains Personal Data

No

## Contains Sensitive Data

No

## Failover Architecture Type

None

## Failover Process Type

NotApplicable

## Failback Process Type

NotApplicable

## Failover Details

NotApplicable

## Data Recovery Process Type

NotApplicable

## Data Recovery Details

NotApplicable

## Release Process Type

PartiallyAutomated

## Rollback Process Type

NotApplicable

## Release Details

Follow the steps in the [UPP MSK Provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-msk-provisioner/README.md).

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-provisioner" user credentials are used during provisioning only.

## Monitoring

Check the MSK dashboard in the AWS console

Login into the AWS Prod Account `FT Tech Content Platform Prod`.

- [C&M Prod MSK EU](https://eu-west-1.console.aws.amazon.com/msk/home?region=eu-west-1#/cluster/arn%3Aaws%3Akafka%3Aeu-west-1%3A469211898354%3Acluster%2Fupp-prod-msk-eu%2F9239e658-3b12-43df-b780-3cfc3ee952d6-4/view?tabId=metrics)
- [C&M Prod MSK US](https://us-east-1.console.aws.amazon.com/msk/home?region=us-east-1#/cluster/arn%3Aaws%3Akafka%3Aus-east-1%3A469211898354%3Acluster%2Fupp-prod-msk-us%2F62135d1f-384d-4e58-9fe6-f6142c6240af-5/view?tabId=metrics)

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

There is no need for any second line troubleshooting.
