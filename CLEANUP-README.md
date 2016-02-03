# CLEANUP - trashing a cluster cleanly

* Go to http://awslogin.internal.ft.com/InfraProd and log in 

* Under EC2 Instances, search for your instances by $ENVIRONMENT_TAG and terminate.

* Under Load Balancers: find and delete your ELB

    * Currently you'll have to find your ELB based on creation date, and check the tags

* The next day, you can delete the Security Group: find your group and delete:

    * In search bar, use `tag:coco-environment-tag :` followed by value for $ENVIRONMENT_TAG

## TODO

George to talk to Valuks about using tagbot to remove unused artefacts.
