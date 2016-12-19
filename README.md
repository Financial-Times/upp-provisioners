# Neo4j HA Cluster

Basic useful feature list:

 * Deploy cluster of 3 Neo4j nodes with 3 ELBs and an ALB


## CloudFormation

Upload [neo4jhacluster.yaml](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/cloudformation/neo4jhacluster.yaml) to CloudFormation on AWS Console to spin up cluster.

You need to specify unique _Stack name_ in CF configuration. Otherwise use defaul values.

Once stack has been deployed you should be able to find your EC2 instances and Load Balancer by searching object with the stack name.

## SSH onto cluster nodes

Search for nodes on AWS Console using your stack name as search key word.

Click one of the nodes and you'll find public IP on Description tab.

To SSH onto the node use the following command syntax.

`ssh -i mykey.pem ec2-user@<public-ip>`
