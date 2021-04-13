#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ $# -ne 1 ]; then
  cat <<EOF
Script to manage the a Route53 CNAME record.
Usage:
$(basename "$0") <Action>
Actions:
  UPSERT - Create or update a Route53 CNAME record
  DELETE - Delete a Route53 CNAME record
EOF

  exit 1
fi

CNAME_ACTION=${1}

DNS_STS_ASSUME_ROLE_ARN="arn:aws:iam::345152836601:role/route53-iam-dnsonlyroleuppprodE94AAA36-CAPB27QPX3K8"
DNS_HOSTED_ZONE_NAME="upp.ft.com"
DNS_HOSTED_ZONE_ID="ZE8P6HDQA4Y9N"

TARGET_SERVICE_DNS_PREFIX=${DNS_CNAME}
TARGET_SERVICE_FQDN="${TARGET_SERVICE_DNS_PREFIX}.${DNS_HOSTED_ZONE_NAME}"
DB_DNS_NAME=${DB_HOSTNAME}
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY}

if [[ "${CNAME_ACTION}" != 'UPSERT' && "${CNAME_ACTION}" != 'DELETE'  ]]; then
  echo "Unknown action \"${CNAME_ACTION}\""
  exit 1
fi


echo "Assume the Route53 DNS prod role"
DNS_STS_ASSUME_ROLE=$(
  aws sts assume-role \
    --role-arn "${DNS_STS_ASSUME_ROLE_ARN}" \
    --role-session-name "pac-aurora-provisioner"
)

AWS_ACCESS_KEY_ID=$(echo "${DNS_STS_ASSUME_ROLE}" | jq -r .Credentials.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo "${DNS_STS_ASSUME_ROLE}" | jq -r .Credentials.SecretAccessKey)
AWS_SESSION_TOKEN=$(echo "${DNS_STS_ASSUME_ROLE}" | jq -r .Credentials.SessionToken)

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN

aws sts get-caller-identity

echo "Generate change set file..."
COMMENT="Auto change action $CNAME_ACTION @ $(date) from the pac-aurora-provisioner"
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
                "Value":"${DB_DNS_NAME}"
              }
            ],
            "Name":"${TARGET_SERVICE_FQDN}",
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
