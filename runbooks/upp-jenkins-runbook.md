<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# UPP - upp-jenkins

Jenkins machines used by UPP

## Code

upp-jenkins

## Primary URL

https://github.com/Financial-Times/upp-provisioners

## Service Tier

Bronze

## Lifecycle Stage

Production

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

<!-- Placeholder - remove HTML comment markers to activate
## Heroku Pipeline Name
Enter descriptive text satisfying the following:
This is the name of the Heroku pipeline for this system. If you don't have a pipeline, this is the name of the app in Heroku. A pipeline is a group of Heroku apps that share the same codebase where each app in a pipeline represents the different stages in a continuous delivery workflow, i.e. staging, production.

...or delete this placeholder if not applicable to this system
-->

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

1.  Login into the Jenkins box using SSH
2.  Login into AWS in the 'ft-tech-content-platform-prod'.
3.  Access this link to find the EC2 instance running Jenkins
4.  ssh to that IP: ssh &lt;your_ft_username>@&lt;jenkins_private_ip>
    Delete the contents of the /var/lib/jenkins/caches folder: rm -rf /var/lib/jenkins/caches/\*
    At this point you can either trigger the scanning of the multibranch pipeline manually, or you can wait for Jenkins to do it automatically.

For more please refer to the GitHub repository README for troubleshooting information.

## Second Line Troubleshooting

Please refer to the GitHub repository README for troubleshooting information.