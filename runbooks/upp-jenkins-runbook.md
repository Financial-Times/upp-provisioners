# UPP - upp-jenkins

Jenkins machines used by UPP

## Code

upp-jenkins

## Primary URL

<https://github.com/Financial-Times/upp-provisioners>

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

See the [upp-provisioners](https://github.com/Financial-Times/upp-provisioners) repository for details.

The following instances reside in AWS:

<https://upp-k8s-jenkins.in.ft.com>: holds critical jobs used for deploying on the Kubernetes UPP clusters and for publishing different content. See Deployment process in K8S clusters spec
<https://content-jenkins.in.ft.com>: holds non-critical jobs mainly migrated from the old on premise jenkins instances that build puppet modules & different libraries.

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

Manual

## Data Recovery Details

Restore from backup. See the [upp-provisioners](https://github.com/Financial-Times/upp-provisioners) repository for details.

## Release Process Type

PartiallyAutomated

## Rollback Process Type

Manual

## Release Details

See the [upp-provisioners](https://github.com/Financial-Times/upp-provisioners) repository for details.

## Key Management Process Type

NotApplicable

## Key Management Details

There is no key rotation procedure for this system.

## Monitoring

NotApplicable

## First Line Troubleshooting

Case 1: Multibranch Pipeline indexing stops working

You can spot this case if the pipelines doesn't trigger for a newly created release.

Look in the "Scan Multibranch Pipeline Log" for that job, and if you see any error it might be because the cache that Jenkins keeps for that Git repository got corrupted some way.

We need to clear the cache so that Jenkins will recover.

Do the following:

1. Login into the Jenkins box using SSH
2. Login into AWS in the 'ft-tech-content-platform-prod'.
3. Access this link to find the EC2 instance running Jenkins
4. ssh to that IP: ssh <your_ft_username>@<jenkins_private_ip>
Delete the contents of the /var/lib/jenkins/caches folder: rm -rf /var/lib/jenkins/caches/*
At this point you can either trigger the scanning of the multibranch pipeline manually, or you can wait for Jenkins to do it automatically.

For more please refer to the GitHub repository README for troubleshooting information.

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.
