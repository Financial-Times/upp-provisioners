# upp-provisioners
Contains the various provisioning projects used by the Universal Publishing Platform.
See the relevant readme file of each project for more detail about each provisioner.

### [upp-concept-publishing-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-concept-publishing-provisioner)

CloudFormation to spin up an S3 bucket, SNS Topic and 1/2 SQS Queues to be used as part of the event-driven concept publishing pipeline.  

### [upp-coreupdate-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-coreupdate-provisioner)

CloudFormation to spin up an S3 bucket, SNS Topic and 1/2 SQS Queues to be used as part of the event-driven concept publishing pipeline.  

### [upp-delivery-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-delivery-provisioner)

Docker image, which runs an Ansible playbook to provision and decommission UPP delivery clusters.

### [upp-elasticsearch-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-elasticsearch-provisioner)

Docker image, running Ansible & CloudFormation to provision and decommission UPP ElasticSearch clusters.

### [upp-neo4j-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-neo4j-provisioner)

Docker image, running Ansible & CloudFormation to provision and decommission UPP Neo4j persistent data clusters.

### [upp-pub-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-pub-provisioner)

Docker image, running Ansible to provision and decommission UPP publishing clusters.

### [upp-rds-provisioner](https://github.com/Financial-Times/upp-provisioners/tree/master/upp-rds-provisioner)

Docker image, running Ansible & CloudFormation to provision and decommission UPP AWS RDS stacks.
