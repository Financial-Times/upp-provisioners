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
  - Generate credentials for the IAM user `content-jenkins-provisioner` in `content-prod` aws account
  - generate a Konstructor DNS API key in slack: /getkeyfor kon_dns content-jenkins universal.publishing.platform@ft.com`

- Run the following Docker commands:
```
docker pull coco/content-jenkins-provisioner:latest
docker run \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "ENVIRONMENT_TYPE=$ENVIRONMENT_TYPE" \
    -e "INSTANCE_NAME=$INSTANCE_NAME" \
    -e "KONSTRUCTOR_API_KEY=$KONSTRUCTOR_API_KEY" \
    coco/content-jenkins-provisioner:latest /bin/bash provision.sh
```

- You can check the progress of the CF stack creation in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).
- kill the Konstructor key: `/killkeyfor [change key] [api key]`

## Decommissioning a Jenkins instance
- Grab, customize and export the environment variables from the **UPP Jenkins - Provisioning & Decommissioning** LastPass note.
- Generate credentials for the IAM user `content-jenkins-provisioner` in `content-prod` aws account
- generate a Konstructor DNS API key in slack: /getkeyfor kon_dns content-jenkins universal.publishing.platform@ft.com`

- Run the following Docker commands:
```
docker pull coco/content-jenkins-provisioner:latest
docker run \
    -e "AWS_ACCOUNT=$AWS_ACCOUNT" \
    -e "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "INSTANCE_NAME=$INSTANCE_NAME" \
    -e "KONSTRUCTOR_API_KEY=$KONSTRUCTOR_API_KEY" \
    coco/content-jenkins-provisioner:latest /bin/bash decom.sh
```

- You can check the progress of the CF stack deletion in the AWS console [here](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks).
- kill the Konstructor key: `/killkeyfor [change key] [api key]`

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

## How to provision a staging env

Testing a Jenkins update or introducing a new Jenkins plugin requires a staging environment.
This can be achieved at this moment in the following way:

1. Provision a new Jenkins box using this provisioner
1. Restore the backed up EBS snapshot, but mount it on this new provisioned instance. See [Restoring an EBS snapshot](#restoring-an-ebs-snapshot)
1. On startup Jenkins will load all of your jobs that are also on production, so please be aware that any job triggered automatically in the jenkins prod will also be triggered for your instance.
   In order to prevent this just delete the jobs configurations that are triggering deploys from the disk. To do this do the following:

    1. Login onto the Jenkins box:

   `ssh ${your_username}@${jenkins_instance_private_ip}`

    1. Remove the Job configs:
       ```
       sudo service jenkins stop \
       && sudo rm -rf /var/lib/jenkins/jobs/k8s-deployment/jobs/apps-deployment/ \
       && sudo rm -rf /var/lib/jenkins/jobs/k8s-deployment/jobs/pac-apps-deployment/ \
       && sudo service jenkins start
       ```

1. Do the tests you need
1. Decommission the Jenkins instance
