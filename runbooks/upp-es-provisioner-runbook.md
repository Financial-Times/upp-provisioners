# UPP ElasticSearch Provisioner

Provisions ElasticSearch clusters for Universal Publishing Platform.

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/upp-elasticsearch-provisioner>

## Code

upp-elasticsearch-provisioner

## Service Tier

Bronze

## Lifecycle Stage

Production

## Delivered By

content

## Supported By

content

## Known About By

- hristo.georgiev
- georgi.ivanov
- elitsa.pavlova
- miroslav.gatsanoga
- mihail.mihaylov
- boyko.boykov

## Host Platform

AWS

## Architecture

This is a provisoner used on-demand by the C&M team. It is based on Ansible playbooks that operate on AWS Cloudformation stacks.

## Contains Personal Data

No

## Contains Sensitive Data

No

## Dependencies

- github

## Failover Architecture Type

None

## Failover Process Type

None

## Failback Process Type

None

## Failover Details

There is no failover available because this is a tool.

## Data Recovery Process Type

None

## Release Process Type

PartiallyAutomated

## Rollback Process Type

PartiallyAutomated

## Release Details

Standard Git releases flow.

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "upp-elasticsearch-provisioner" user credentials are used during provisioning only.

## Monitoring

There is not need for monitoring because this is a tool.

## First Line Troubleshooting

Please refer to the GitHub [README](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-elasticsearch-provisioner/README.md) for more information.

## Second Line Troubleshooting

There is no need for any second line troubleshooting.
