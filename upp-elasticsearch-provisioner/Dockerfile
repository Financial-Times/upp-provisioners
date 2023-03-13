FROM ubuntu:22.04

ENV ANSIBLE_HOSTS=/ansible/hosts

# stops tzdata configuration prompt
ENV DEBIAN_FRONTEND=noninteractive

# Dependancy explanation
# python2 python-pip are used by register-es-snapshot-dir.py script
# curl unzip jq are used by register-snapshot-bucket.sh script
RUN apt-get update && apt-get install -y python2 python-pip ansible ca-certificates curl unzip jq
RUN pip2 install boto boto3 dnspython
RUN update-ca-certificates 2&>1 > /dev/null

# old setup
COPY ansible /ansible
COPY cloudformation /cloudformation
COPY scripts/* /usr/local/bin/

# new setup
RUN get-latest-awscli2

COPY config /config
COPY utils /utils

