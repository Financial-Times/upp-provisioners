# CloudFormation README

Documentation for Neo4j HA Cluster CloudFormation templates.

### Table of Contents
**[Templates](#templates)**  
**[up-neo4j-ha-cluster-subnets.yaml](#up-neo4j-ha-cluster-subnets.yaml)**  
**[neo4jhacluster.yaml](#neo4jhacluster.yaml)**  


## Templates



### [up-neo4j-ha-cluster-subnets.yaml](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/cloudformation/up-neo4j-ha-cluster-subnets.yaml)

This template creates the following resources:

 *  3 public /24 subnets
 *  3 private /24 subnets
 *	1 NAT Gateway with ElasticIP for each public subnet
 *	1 route table per private subnet that routes traffic to destination 0.0.0.0/0 via NAT Gateway in public subnet that lives in the same AZ as the private subnet
 *	All resources that supports tagging are tagged

#### Usage

Stack is designed to be managed from the command line using AWS CLI. See [Run container](https://github.com/Financial-Times/up-neo4j-ha-cluster#run-container) section in [main README.md](https://github.com/Financial-Times/up-neo4j-ha-cluster).

Once you have [set up AWS credentials](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) you can use the following commands to manage the stack.

##### Validate template

 `aws cloudformation validate-template --template-body file://///mnt//neo//cloudformation//up-neo4j-ha-cluster-subnets.yaml`

##### Create stack

`aws cloudformation create-stack --stack-name up-neo4j-ha-cluster-subnets --template-body file://///mnt//neo//cloudformation//up-neo4j-ha-cluster-subnets.yaml`

##### Update stack

`aws cloudformation update-stack --stack-name up-neo4j-ha-cluster-subnets --template-body file://///mnt//neo//cloudformation//up-neo4j-ha-cluster-subnets.yaml`

##### Delete stack

`aws cloudformation delete-stack --stack-name up-neo4j-ha-cluster-subnets`

---

### [up-neo4j-ha-cluster-subnets-jumpbox.yaml](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/cloudformation/up-neo4j-ha-cluster-subnets-jumpbox.yaml)

Stack that creates an EC2 instance and a security group that allows SSH access from known subnets and IP addresses.

##### Create stack

`aws cloudformation create-stack --stack-name up-neo4j-ha-cluster-subnets-jumpbox --template-body file://///mnt//neo//cloudformation//up-neo4j-ha-cluster-subnets-jumpbox.yaml`

##### Delete stack

`aws cloudformation delete-stack --stack-name up-neo4j-ha-cluster-subnets-jumpbox`

---

### [neo4jhacluster.yaml](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/cloudformation/neo4jhacluster.yaml)

Documentation for this template to be added soon....
