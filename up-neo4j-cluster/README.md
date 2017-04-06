# up-concept-publishing-provisioner

Cloudoformation to spin up an S3 bucket, SNS Topic and 1/2 SQS Queues to be used as part of the event-driven concept publishing pipeline.  

## Provisioning
The script can be used directly in the AWS Console.  You need to provide two parameters:
- Environment tag - Which environment this belongs to.
- IsMultiRegion - Whether the stack needs to be read in multiple regions (will spin up 2 SQS queues rather than 1).

## Decomissioning
You can decom the stack by deleting it from the AWS Console.  If the bucket has content in, the stack will fail to delete.  In this case, you should do one of the following:
- If you don't need the bucket, manually delete it and then re-delete the stack.  It should successfully work.
- If you want to keep the bucket, re-delete the stack and it should prompt you whether you want to ignore the bucket.  Say yes and the stack should delete leaving the bucket alone.
