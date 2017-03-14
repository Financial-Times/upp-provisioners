#!/usr/bin/python2.7
from boto.connection import AWSAuthConnection
import argparse
import json

parser = argparse.ArgumentParser(description='Registers an AWS ElasticSearch domain with an S3 bucket to allow manual snapshots and restores.')
parser.add_argument('-r','--region', help='AWS region of the S3 bucket',required=True)
parser.add_argument('-e','--endpoint', help='ElasticSearch domain endpoint',required=True)
parser.add_argument('-a','--access_key', help='AWS access key',required=True)
parser.add_argument('-s','--secret_key', help='AWS secret key',required=True)
parser.add_argument('-b','--bucket', help='S3 bucket name',required=True)
args = parser.parse_args()

class ESConnection(AWSAuthConnection):

    def __init__(self, region, **kwargs):
        super(ESConnection, self).__init__(**kwargs)
        self._set_auth_region_name(region)
        self._set_auth_service_name("es")

    def _required_auth_capability(self):
        return ['hmac-v4']

if __name__ == "__main__":

    client = ESConnection(
            region=args.region,
            host=args.endpoint,
            aws_access_key_id=args.access_key,
            aws_secret_access_key=args.secret_key, is_secure=False)

    print 'Registering Snapshot Repository'

    payload = {
        "type": "s3",
        "settings": {
            "bucket": args.bucket,
            "region": args.region,
            "role_arn": "arn:aws:iam::810385116814:role/upp-concepts-cf-testing"
            }
        }

    resp = client.make_request(method='POST',
            path='/_snapshot/index-backups',
            data=json.dumps(payload)
        )
    body = resp.read()
    print body
