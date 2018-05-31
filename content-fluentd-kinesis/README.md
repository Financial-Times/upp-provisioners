# Content Fluentd Kinesis Provisioner

Provisions a new Kinesis stream which will process logs from the Content fluentd instance running within an UPP/PAC Kubernetes cluster.

## Building the Docker image

The Content Fluentd Kinesis Provisioner can be built locally as a Docker image:

`docker build -t content-fluentd-kinesis:local .`

## IMPORTANT: Check Shard Count

The throughput of events Kinesis is capable of processing is controlled by the number of Shard provisioned using this Docker image. If you require more throughput, please reconfigure the number of shards.

For more details, see the kinesis documentation [here](https://docs.aws.amazon.com/streams/latest/dev/key-concepts.html).

## Provisioning a new Kinesis stream

The provisioning process will:

* Create a new Kinesis stream in the region of choice.

To provision a new Content Fluentd Kinesis:

* Generate credentials for the IAM user `content-fluentd-kinesis-provisioner` in the content-test AWS account for a Dev stack or in the content-prod AWS account for a Staging/Prod stack.
* Using the new credentials, set the following environment variables:

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=                  # This will determine which AWS region the kinesis stream will be provisioned in
export CLUSTER=                     # This will be appended to `content-fluentd-kinesis` for the infrastructure
export ENVIRONMENT_TYPE=            # This should be the type of environment the cluster will be, i.e. `t` for staging, `p` for production and `d` for anything else
```

* Run the following docker command

```
docker run \
    -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    -e "AWS_REGION=${AWS_REGION}" \
    -e "CLUSTER=${CLUSTER}" \
    -e "ENVIRONMENT_TYPE=${ENVIRONMENT_TYPE}" \
    content-fluentd-kinesis:local /bin/bash provision.sh
```

## Decommissioning a Kinesis Stream

The decommissioning process will:

* Decommission the Kinesis stream for the provided Cluster in the specified region.

To decommission the Content Fluentd Kinesis Stream:

* Generate credentials for the IAM user `content-fluentd-kinesis-provisioner` in content-test AWS account for a Dev stack or in content-prod AWS account for a Staging/Prod stack.
* Using the new credentials, set the following environment variables:

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=                  # This will determine which AWS region the kinesis stream will be decommissioned from
export CLUSTER=                     # The cluster that you wish to decommission, i.e. `dev`.
```

* Run the following docker command

```
docker run \
    -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    -e "AWS_REGION=${AWS_REGION}" \
    -e "CLUSTER=${CLUSTER}" \
    annotations-monitoring:local /bin/bash decom.sh
```
