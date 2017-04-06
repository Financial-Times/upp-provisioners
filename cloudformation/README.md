# CloudFormation README

Documentation for Neo4j HA Cluster CloudFormation templates.

### Table of Contents
**[Templates](#templates)**  
**[up-neo4j-ha-cluster-subnets.yaml](#up-neo4j-ha-cluster-subnetsyaml)**  
**[jumpbox.yaml](#jumpboxyaml)**  
**[neo4jhacluster.yaml](#neo4jhaclusteryaml)**  


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

##### Create stack in non-default VPC

To create stack in other than default VPC you will need to specify the VPC ID and Route Table associated with VPC.
You can find this information via AWS console.

Once you have details you can can pass them as command line parameters in the following way.

```
aws cloudformation create-stack --stack-name up-neo4j-ha-cluster-subnets-semantic --template-body file://///mnt//neo//cloudformation//up-neo4j-ha-cluster-subnets.yaml \
--parameters ParameterKey=VPC,ParameterValue=vpc-9fcb94fb \
ParameterKey=PublicSubnetRouteTableId,ParameterValue=rtb-6d739b0a
```

##### Update stack

`aws cloudformation update-stack --stack-name up-neo4j-ha-cluster-subnets --template-body file://///mnt//neo//cloudformation//up-neo4j-ha-cluster-subnets.yaml`


##### Delete stack

`aws cloudformation delete-stack --stack-name up-neo4j-ha-cluster-subnets`

---

### [jumpbox.yaml](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/cloudformation/jumpbox.yaml)

Stack that creates an EC2 instance and a security group that allows SSH access from known subnets and IP addresses.

##### Create stack in default VPC
NB! We assume that our default VPS is in eu-west-1 AWS region where all our clusters reside.
```
aws cloudformation create-stack --stack-name up-neo4j-jumpbox-uk \
--template-body file://///mnt//neo//cloudformation//jumpbox.yaml \
--parameters ParameterKey=KonstructorAPIKey,ParameterValue=abcdefghijklmnop
```

###### Create stack in non-default VPC

To deploy jumpbox in non-default VPC you need to specify VPC ID, subnets for all 3 AvailabilityZones, InstanceKey and the region (if it is not eu-west-1).  
_InstanceKey is AWS Key Pair that allows creation of EC2 instances._
###### Example: create a stack in us-east-1 AWS region
```
aws --region us-east-1 cloudformation create-stack --stack-name up-neo4j-jumpbox-us \
--template-body file://///mnt//neo//cloudformation//jumpbox.yaml \
--parameters ParameterKey=VPC,ParameterValue=vpc-4e5dc82b \
ParameterKey=KonstructorAPIKey,ParameterValue=abcdefghijklmnop \
ParameterKey=Subnet1,ParameterValue=subnet-4e94b738 \
ParameterKey=Subnet2,ParameterValue=subnet-24dfb47c \
ParameterKey=Subnet3,ParameterValue=subnet-51654c35 \
ParameterKey=Subnet3,ParameterValue=subnet-51654c35 \
ParameterKey=InstanceKey,ParameterValue=UP_NVirginia_Key \
```

##### Delete stack

`aws cloudformation --region us-east-1 delete-stack --stack-name up-neo4j-jumpbox-us`

---

### [neo4jhacluster.yaml](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/cloudformation/neo4jhacluster.yaml)

##### Create stack

Neo4j HA Cluster is span up with script [provision.sh](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/provision.sh).
Before running the script you must set the following environment variables.

```
export ENVIRONMENT_TAG="unique-env-name"
export AWS_ACCESS_KEY_ID="key"
export AWS_SECRET_ACCESS_KEY="secret"
export AWS_DEFAULT_REGION="eu-west-1|us-east-1"
export SERVICES_DEFINITION_ROOT_URI="https://raw.githubusercontent.com/Financial-Times/up-neo4j-service-files/master/"
export SPLUNK_HEC_TOKEN="splunk-token"
export SPLUNK_HEC_URL="https://http-inputs-financialtimes.splunkcloud.com/services/collector/event"
export KONSTRUCTOR_API_KEY="konstructor-key"
export NEO_EXTRA_CONF_URL="https://raw.githubusercontent.com/Financial-Times/up-neo4j-service-files/master/neo4j-extra-conf.sh"
export TOKEN_URL=$(curl -s https://discovery.etcd.io/new?size=3)
export ENVIRONMENT_TYPE="d|t|p"

```

Once environment variables are set start provisioning with the following command.

```
./provision.sh

# Example command output
Creating stack for environment unique-env-name
{
    "StackId": "arn:aws:cloudformation:eu-west-1:027104099916:stack/up-neo4j-unique-env-name/6ea4b860-edf8-11e6-a7fd-503ac9e74c61"
}
```

##### Delete stack

`aws cloudformation delete-stack --stack-name up-neo4j-unique-env-name`
