#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'


if [ $# -ne 1 ]; then
  cat <<EOF
Script to manage the Jumpbox ELB CNAME record.
Usage:
$(basename "$0") <Action>
Actions:
  UPSERT - Create or update a Route53 CNAME record
  DELETE - Delete a Route53 CNAME record
EOF

  exit 1
fi

CNAME_ACTION=${1}

JUMPBOX_FQDN="upp-jumpbox-${ENVIRONMENT_TYPE}.upp.ft.com"
echo $JUMPBOX_FQDN

echo "Get the Jumpbox ELB DNS Name"
JUMPBOX_ELB_DNS_NAME=$(
  aws cloudformation describe-stacks \
    --output text \
    --region "${AWS_REGION}" \
    --stack-name "${CF_STACK_NAME}" \
    --query "Stacks[0].Outputs[?OutputKey=='JumpboxELBDNSname'].OutputValue"
)

echo "Assume the Route53 DNS prod role"
DNS_STS_ASSUME_ROLE=$(
  aws sts assume-role \
    --role-arn "${DNS_STS_ASSUME_ROLE_ARN}" \
    --role-session-name "upp-jumpbox-provisioner-session"
)

AWS_ACCESS_KEY_ID=$(echo "${DNS_STS_ASSUME_ROLE}" | jq -r .Credentials.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo "${DNS_STS_ASSUME_ROLE}" | jq -r .Credentials.SecretAccessKey)
AWS_SESSION_TOKEN=$(echo "${DNS_STS_ASSUME_ROLE}" | jq -r .Credentials.SessionToken)

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN

aws sts get-caller-identity

echo "Generate change set file..."
COMMENT="Auto change action $CNAME_ACTION @ $(date) from the upp-jumpbox-provisioner"
TMPFILE=$(mktemp /tmp/manage-cname-temporary-file.XXXXXXXX)
cat > "${TMPFILE}" << EOF
    {
      "Comment":"${COMMENT}",
      "Changes":[
        {
          "Action":"${CNAME_ACTION}",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"${JUMPBOX_ELB_DNS_NAME}"
              }
            ],
            "Name":"${JUMPBOX_FQDN}",
            "Type":"CNAME",
            "TTL": 30
          }
        }
      ]
    }
EOF

cat "${TMPFILE}"

echo "Change record set..."
aws route53 change-resource-record-sets \
  --hosted-zone-id "${DNS_HOSTED_ZONE_ID}" \
  --change-batch file://"${TMPFILE}"

rm "${TMPFILE}"

echo "Done. DNS action completed."
