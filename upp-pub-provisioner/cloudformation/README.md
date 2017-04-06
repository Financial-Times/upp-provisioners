# Coco Management Server

Coco Management Server is an Amazon Linux server with FT integration (ldap authentication, etc.).

Management Server provides Docker runtime, Go development environment and utilities such as Git client.



## Usage

### Creating CloudFormation stack

1. Log on to AWS Console and go to CloudFormation view
2. Click _Create Stack_ button
3. Select _Upload a template to Amazon S3_ and click _Browse_ button
4. Select the CloudFormation template (cloudformation/*.json) that you wish to upload, then click _Next_ button
5. Provide _Stack name_ and click _Next_ button
6. In _Options_ view click _Next_ button
7. In _Review_ view click _Create_ button to create the stack


### Updating existing CloudFormation stack

__WARNING!__ Updating stack may cause instance to be rebooted

1. In CloudFormation menu select the stack you wish to update
2. Click _Update Stack_ button
3. Select _Upload a template to Amazon S3_ and click _Browse_ button
4. In _Specify Details_ click _Next_ button


### Deleting CloudFormation stack
1. In CloudFormation menu select the stack you wish to update
2. Click _Actions_ and choose _Delete Stack_
3. Confirm deletion


## Support

If you experience any issues or want to contribute to this project contact jussi.heinonen@ft.com