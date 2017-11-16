# Jenkins provisioner

[![CircleCI](https://circleci.com/gh/Financial-Times/content-provisioners.svg?style=shield)](https://circleci.com/gh/Financial-Times/content-provisioners)

The Jenkins provisioning process will:

 * Create a blank EC2 instance, and attach an ALB
 * Create or update an appropriate CNAME record for the instance

The new instance will be tagged with `scheduler:ebs-snapshot`, which will automatically take nightly EBS snapshots of the instance volume. See [here](http://docs.aws.amazon.com/solutions/latest/ebs-snapshot-scheduler/overview.html) for more details.

Note that the provisioner will not automatically install Jenkins or deploy any config.
Our current plan is to manually restore the previous EBS snapshot from an existing Jenkins - see [here](https://github.com/Financial-Times/content-provisioners/tree/master/content-jenkins-provisioner#restoring-an-ebs-snapshot) for more details.

The decommissioning process will:

 * Destroy the EC2 instance and ALB
 * Delete the CNAME record
 * EBS snapshots will automatically be tidied up after 7 days

## Building the Docker image
The Jenkins provisioner can be built locally as a Docker image:

`docker build -t coco/content-jenkins-provisioner:local .`

Automated CircleCI builds are also triggered on branch commits and merges to master, located [here](https://circleci.com/gh/Financial-Times/content-provisioners).

## Provisioning a Jenkins instance
- Grab, customize and export the environment variables from the **UPP Jenkins - Provisioning & Decommissioning** LastPass note.
- Run the following Docker commands:
```
docker pull coco/content-jenkins-provisioner:latest
docker run \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "INSTANCE_NAME=$INSTANCE_NAME" \
    -e "VAULT_PASS=$VAULT_PASS" \
    coco/content-jenkins-provisioner:latest /bin/bash provision.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).

## Decommissioning a Jenkins instance
- Grab, customize and export the environment variables from the **UPP Jenkins - Provisioning & Decommissioning** LastPass note.
- Run the following Docker commands:
```
docker pull coco/content-jenkins-provisioner:latest
docker run \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "INSTANCE_NAME=$INSTANCE_NAME" \
    -e "VAULT_PASS=$VAULT_PASS" \
    coco/content-jenkins-provisioner:latest /bin/bash decom.sh
```

- You can check the progress of the CF stack deletion in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).

## Restoring an EBS snapshot

This is currently a manual process - we plan to automate this fully in future.  
Once you have provisioned a Jenkins instance, perform the following steps:

- On the EC2 console, select `Snapshots`, then select the latest automatic scheduled Jenkins snapshot.

- Select `Create Volume`, and create a volume in `eu-west-1a`.

- Find the new instance in the EC2 console. If it is running, stop the instance.

- Detach the existing volume from the instance.

- Attach the new snapshot-created volume to `/dev/xvda`.

- Power the instance back on.

The new instance should now boot with a complete copy of the data from the snapshot.
