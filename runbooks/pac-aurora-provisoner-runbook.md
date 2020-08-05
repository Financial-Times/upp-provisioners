# UPP - pac-aurora-provisoner

Provisions Aurora RDS for Platform for Annotation Curation (PAC)

## Code

pac-aurora-provisoner

## Primary URL

<https://github.com/Financial-Times/upp-provisioners/tree/master/pac-aurora-provisioner>

## Service Tier

Bronze

## Lifecycle Stage

Production

## Delivered By

content

## Supported By

content

## Known About By

- dimitar.terziev
- elitsa.pavlova
- hristo.georgiev
- donislav.belev
- mihail.mihaylov
- boyko.boykov

## Host Platform

AWS

## Architecture

The PAC Aurora database is an Amazon Aurora MySQL RDS cluster of 4 database instances spread between two AWS regions - eu-west-1 and us-east-1.

[Regional DNS architecture](https://www.lucidchart.com/publicSegments/view/b0f16f1b-6393-45ff-91a6-d1da1274e722/image.png)
[Broader architecture diagram](https://www.lucidchart.com/publicSegments/view/22c1656b-6242-4da6-9dfb-f7225c20f38f/image.png)

## Contains Personal Data

No

## Contains Sensitive Data

No

## Failover Architecture Type

NotApplicable

## Failover Process Type

NotApplicable

## Failback Process Type

NotApplicable

## Failover Details

NotApplicable

## Data Recovery Process Type

NotApplicable

## Data Recovery Details

The service does not store data, so it does not require any data recovery steps.

## Release Process Type

PartiallyAutomated

## Rollback Process Type

Manual

## Release Details

The release is triggered by making a Github release which is then picked up by a Jenkins multibranch pipeline. The Jenkins pipeline should be manually started in order for it to deploy the helm package to the Kubernetes clusters.

## Key Management Process Type

NotApplicable

## Key Management Details

There is no key rotation procedure for this system.

## Monitoring

NotApplicable

## First Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.
