#!/usr/bin/env bash

echo "Registering S3 snapshot repository for \"$CF_STACK_NAME\""
echo "Looking for S3 \"$BACKUP_BUCKET\" bucket"
BACKUP_BUCKET_CHECK="$(aws s3api head-bucket --bucket="$BACKUP_BUCKET" 2>&1)"
if [ "$BACKUP_BUCKET_CHECK" != "" ]; then
  echo -e "Error - Failed to get s3 backup bucket $BACKUP_BUCKET\n"
  echo -e "Check if the S3 bucket exists and is accessible with the provided credentials."
  echo
  exit 1
else
  echo "Found: \"$BACKUP_BUCKET\" bucket."
fi

echo "Looking for backup role \"$BACKUP_ROLE\""
BACKUP_ROLE_ARN="$(aws iam get-role --role-name=$BACKUP_ROLE 2>/dev/null | jq .Role.Arn -r)"
if [ "$BACKUP_ROLE_ARN" == "" ]; then
  echo -e "Error - Failed to get \"upp-elasticsearch-backup-role\"\n"
  echo -e "Check if the IAM role exists and is accessible with the provided credentials."
  echo
  exit 1
else
  echo "Found: \"$BACKUP_ROLE_ARN\" IAM backup role."
fi

echo "Looking for es domain endpoint."
ES_ENDPOINT="https://$(
  aws es describe-elasticsearch-domain --domain-name="$CF_STACK_NAME" 2>/dev/null | jq .DomainStatus.Endpoint -r
)"
if [ "$ES_ENDPOINT" == "https://" ]; then
  echo -e "Error - Failed to get es endpoint for $CF_STACK_NAME\n"
  echo -e "Check if the ES domain exists and is accessible with the provided credentials."
  echo
  exit 1
else
  echo "Found: \"$ES_ENDPOINT\" domain endpoint."
fi

/register-es-snapshot-dir.py -r "$AWS_DEFAULT_REGION" -e "$ES_ENDPOINT" -a "$AWS_ACCESS_KEY" -s "$AWS_SECRET_ACCESS_KEY" -b "$BACKUP_BUCKET" -o "$BACKUP_ROLE_ARN"