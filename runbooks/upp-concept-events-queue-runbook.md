# UPP Concept Events Queue

SQS queue used to propagate concept publishing events.

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/upp-concept-events-pipeline-provisioner>

## Code

upp-concept-events-queue

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
- marina.chompalova
- miroslav.gatsanoga
- donislav.belev
- boyko.boykov
- mihail.mihaylov

## Host Platform

AWS

## Architecture

SQS queue provisioned along with a deadletter queue. The 
aggregate-concept-transformer service is producing messages to the queue and concept-events-notifications service is consuming them.

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

## Release Process Type

PartiallyAutomated

## Rollback Process Type

PartiallyAutomated

## Release Details

Follow the provisioning steps in [AWS Concept Events Pipeline provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/upp-concept-events-pipeline-provisioner/README.md).

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
