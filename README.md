# upp-provisioners

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

Contains the various provisioning projects used by the Universal Publishing Platform.
See the relevant readme file of each project for more detail about each provisioner.

### CircleCI Automated Builds

Automated builds for the provisioner projects are triggered in [CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners/).  
The CircleCI configuration is located [here](https://github.com/Financial-Times/upp-provisioners/blob/master/.circleci/config.yml).

Builds are triggered on commits and pull requests, and must pass to be able to merge into master.
Note that only provisioners that have CircleCI configuration defined AND have been updated by your commits will be built.  

Commits to branches are automatically built, tagged and pushed with the branch name as the Docker image tag.  
Note that due to tag naming restrictions, branch names containing `/` will only use the second part as the tag.

To enable automated builds for new provisioner projects that contain a Dockerfile:

- Copy the configuration from an existing job, eg: [upp-elasticsearch-provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/.circleci/config.yml#L76)
- Update the job name to match the name of the new provisioner

No further changes should be required, as the job config is fully parameterised.

### Provisioners

- [content-jenkins-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/content-jenkins-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission Content Jenkins infrastructure.

- [content-eks-jumpbox-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/content-eks-jumpbox-provisioner)
    - Docker image runnning CloudFormation to provision and decommission Content Jumpbox

- [upp-concept-publishing-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-concept-publishing-provisioner)
    - CloudFormation to spin up an S3 bucket, SNS Topic and 1/2 SQS Queues to be used as part of the event-driven concept publishing pipeline.

- [upp-elasticsearch-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-elasticsearch-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission UPP ElasticSearch clusters.

- [upp-factset-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-factset-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission UPP Factset RDS stacks.

- [content-fluentd-kinesis](https://github.com/Financial-Times/upp-provisioners/tree/master/content-fluentd-kinesis)
    - Docker image, running Ansible & CloudFormation to provision and decommission Content Fluentd Kinesis.

- [upp-annotations-monitoring-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-annotations-monitoring-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission Annotations Monitoring Kinesis Analytics Application.

- [upp-msk-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-msk-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission AWS Managed Kafka cluster (MSK).

- [ccf-dynamodb](https://github.com/Financial-Times/upp-provisioners/tree/master/ccf-dynamodb)
    - Docker image, running Ansible & CloudFormation to provision and decommission DynamoDB table used to store client settings for Copyright Cleared Feed.
