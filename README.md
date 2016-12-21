# Neo4j HA Cluster

Basic useful feature list:

 * Deploy cluster of 3 Neo4j nodes with 1 Read and 1 Write ALB


 ## CloudFormation

 Upload [neo4jhacluster.yaml](https://github.com/Financial-Times/up-neo4j-ha-cluster/blob/master/cloudformation/neo4jhacluster.yaml) to CloudFormation on AWS Console to spin up cluster.

 You need to specify unique _Stack name_ in CF configuration. Otherwise use defaul values.

 Once stack has been deployed you should be able to find your EC2 instances and Load Balancer by searching object with the stack name.

 ## SSH access

 Search for nodes on AWS Console using your stack name as search key word.

 Click one of the nodes and you'll find public IP on Description tab.

 To SSH onto the node use the following command syntax.

 `ssh -i mykey.pem ec2-user@<public-ip>`

 # Local development environment

 Local development environment is built on Docker.

 Prefix the following commands with _sudo_ if required.

 ## Build container

 ```
 cd <repo>
 docker build -t neo4jha:local .
 ```

 ### Run container

 Start container, forward ports 7374, 7474, 7687 and mount current working directory as /mnt/neo

 ```
 docker run -p 7473:7473 -p 7474:7474 -p 7687:7687 -v $PWD:/mnt/neo -it neo4jha:local
 ```

 #### Deploy stuff

 Config lives in directory _puppet/_

 To apply config changes in local development environment run the following command.

 ```
 puppet apply --modulepath /mnt/neo/puppet/ -e "class { 'neo4jha': profile => 'dev', initial_hosts => 'localhost:5000' }"
 ```
