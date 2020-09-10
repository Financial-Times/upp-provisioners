# CCF Client Settings DynamoDB

DynamoDB table that contains CCF licences and feeds.

## Code

ccf-client-settings-dynamodb

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/ccf-dynamodb>

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
- donislav.belev
- mihail.mihaylov
- boyko.boykov


## Host Platform

AWS

## Architecture

There is a single DynamoDB table provisioned in N. Virginia (us-east-1) region.

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

Follow the steps in the [Copyright Cleared Feed DynamoDB Provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/ccf-dynamodb/README.md) to provision the DynamoDB table.

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
