<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP Concept Events Queue

SQS queue used to propagate concept publishing events.

## Code

upp-concept-events-queue

## Primary URL

https://github.com/Financial-Times/upp-provisioners/tree/master/upp-concept-events-pipeline-provisioner

## Service Tier

Bronze

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

SQS queue provisioned along with a deadletter queue. The 
aggregate-concept-transformer service is producing messages to the queue and concept-events-notifications service is consuming them.

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

None

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

Follow the provisioning steps in [AWS Concept Events Pipeline provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-concept-events-pipeline-provisioner/README.md).

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

AWS Cloudwatch

## First Line Troubleshooting

Check the SQS dashboard in the AWS console.

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.