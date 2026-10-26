<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP Concept carousel queue provisioner

Provisioner to provision SQS upp-concept-carousel-queue

## Code

upp-concept-carousel-queue-provisioner

## Primary URL

https://github.com/Financial-Times/upp-provisioners/tree/master/upp-sqs-provisioner

## Service Tier

Bronze

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

This is a provisoner used on-demand by the C&M team. It is based on Ansible playbooks that operate on AWS Cloudformation stacks.

## Contains Personal Data

No

## Contains Sensitive Data

No

## Can Download Personal Data

No

## Can Contact Individuals

No

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

<!-- Placeholder - remove HTML comment markers to activate
## Data Recovery Details
Enter descriptive text satisfying the following:
The actions required to restore the data for this system. Either provide a set of numbered steps or a link to a detailed process that operations can follow.

...or delete this placeholder if not applicable to this system
-->

## Release Process Type

PartiallyAutomated

## Rollback Process Type

PartiallyAutomated

## Release Details

Standard Git releases flow.

<!-- Placeholder - remove HTML comment markers to activate
## Heroku Pipeline Name
Enter descriptive text satisfying the following:
This is the name of the Heroku pipeline for this system. If you don't have a pipeline, this is the name of the app in Heroku. A pipeline is a group of Heroku apps that share the same codebase where each app in a pipeline represents the different stages in a continuous delivery workflow, i.e. staging, production.

...or delete this placeholder if not applicable to this system
-->

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM user credentials are used during provisioning only.

## Monitoring

There is not need for monitoring because this is a tool.

## First Line Troubleshooting

NotApplicable

## Second Line Troubleshooting

There is no need for any second line troubleshooting.