# Annotations Monitoring Kinesis Analytics Application Provisioner

Provisions a new Kinesis Analytics application which will process logs from the Content fluentd stream, and monitor for Annotations publishing failures.

## Building the Docker image

The Annotations Monitoring Provisioner can be built locally as a Docker image:

`docker build -t annotations-monitoring:local .`

## Provisioning a Kinesis Analytics application

This guide assumes you already have a Kinesis stream provisioned for the Content Fluentd logs, plus an IAM role able to consume events from that stream. Please have the ARN's ready before beginning this process.

The provisioning process will:

* Create a new Kinesis Analytics Application in the region of choice.
* The application will read from the provided Kinesis stream (which must also exist in the same region), using a specific input schema and SQL code.

To provision a new Annotations Monitoring application:

* Generate credentials for the IAM user `annotations-monitoring-kinesis-analytics-provisioner` in the content-test AWS account for a Dev stack or in the content-prod AWS account for a Staging/Prod stack.
* Using the new credentials, set the following environment va1riables:

```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=                  # This will determine which AWS region the kinesis analytics application stream will be provisioned in - should match the region the kinesis stream is in
export CLUSTER=                     # This will be appended to `annotations-monitoring-kinesis-analytics` for the infrastructure
export ENVIRONMENT_TYPE=            # This should be the type of environment the cluster will be, i.e. `t` for staging, `p` for production and `d` for anything else
export INPUT_KINESIS_STREAM_ARN=    # The ARN for the Kinesis stream this application will read from.
export INPUT_ROLE_ARN=              # The ARN for the IAM Role that grants access to the above Kinesis stream.
```

* Run the following docker command

```
docker run \
    -e "AWS_ACCESS_KEY=${AWS_ACCESS_KEY}" \
    -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    -e "AWS_REGION=${AWS_REGION}" \
    -e "CLUSTER=${CLUSTER}" \
    -e "ENVIRONMENT_TYPE=${ENVIRONMENT_TYPE}" \
    -e "INPUT_KINESIS_STREAM_ARN=${INPUT_KINESIS_STREAM_ARN}" \
    -e "INPUT_ROLE_ARN=${INPUT_ROLE_ARN}" \
    annotations-monitoring:local /bin/bash provision.sh
```

## Decommissioning a Kinesis Analytics application

The decommissioning process will:

* Decommission the Kinesis stream for the provided Cluster in the specified region.

To decommission the Content Fluentd Kinesis Stream:

* Generate credentials for the IAM user `annotations-monitoring-kinesis-analytics-provisioner` in content-test AWS account for a Dev stack or in content-prod AWS account for a Staging/Prod stack.
* Using the new credentials, set the following environment variables:

```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=                  # This will determine which AWS region the kinesis stream will be decommissioned from
export CLUSTER=                     # The cluster that you wish to decommission, i.e. `dev`.
```

* Run the following docker command

```
docker run \
    -e "AWS_ACCESS_KEY=${AWS_ACCESS_KEY}" \
    -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    -e "AWS_REGION=${AWS_REGION}" \
    -e "CLUSTER=${CLUSTER}" \
    annotations-monitoring:local /bin/bash decom.sh
```
