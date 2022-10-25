# UPP Content Exporter S3

Amazon S3 bucket storing FT content exports.

## Code

upp-content-exporter-s3

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/upp-content-exporter-s3-provisioner>

## Service Tier

Bronze

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

A single S3 bucket is provisioned for each environment in the Ireland (eu-west-1) region.

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

None

## Data Recovery Details

None

## Release Process Type

Manual

## Rollback Process Type

Manual

## Release Details

Follow the steps in the [UPP S3 Provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-content-exporter-s3-provisioner/README.md).

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-provisioner" user credentials are used during provisioning only.

## Monitoring

Check the S3 dashboard in the AWS console.

## First Line Troubleshooting

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.
