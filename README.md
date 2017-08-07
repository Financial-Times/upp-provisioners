# upp-provisioners

[![CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/upp-provisioners)

Contains the various provisioning projects used by the Universal Publishing Platform.
See the relevant readme file of each project for more detail about each provisioner.

### CircleCI Automated Builds

Automated builds for the provisioner projects are triggered in [CircleCI](https://circleci.com/gh/Financial-Times/upp-provisioners/).  
The CircleCI configuration is located [here](https://github.com/Financial-Times/upp-provisioners/blob/master/.circleci/config.yml).

Builds are triggered on commits and pull requests, and must pass to be able to merge into master.

Only provisioners that have been updated and have CircleCI configuration defined will be built.

To enable automated builds for new provisioner projects that contain a Dockerfile:

- Copy the configuration from an existing job, eg: [upp-elasticsearch-provisioner](https://github.com/Financial-Times/upp-provisioners/blob/master/.circleci/config.yml#L108-L152)
- Update the job name to match the name of the new provisioner

No further changes should be required, as the job config is fully parameterised.

### Provisioners

- [upp-concept-publishing-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-concept-publishing-provisioner)
    - CloudFormation to spin up an S3 bucket, SNS Topic and 1/2 SQS Queues to be used as part of the event-driven concept publishing pipeline.  

-  [upp-coreupdate-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-coreupdate-provisioner)
    - Provisioning instructions for manually creating a CoreUpdate instance.

- [upp-delivery-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-delivery-provisioner)
    - Docker image, which runs an Ansible playbook to provision and decommission UPP delivery clusters.

- [upp-elasticsearch-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-elasticsearch-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission UPP ElasticSearch clusters.

- [upp-neo4j-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-neo4j-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission UPP Neo4j persistent data clusters.

- [upp-pub-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-pub-provisioner)
    - Docker image, running Ansible to provision and decommission UPP publishing clusters.

- [upp-rds-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-rds-provisioner)
    - Docker image, running Ansible & CloudFormation to provision and decommission UPP AWS RDS stacks.

