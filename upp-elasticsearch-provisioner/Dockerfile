FROM ubuntu:22.04

ENV ANSIBLE_HOSTS=/ansible/hosts

# stops tzdata configuration prompt
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y python3 python3-pip ansible ca-certificates curl unzip
RUN pip3 install boto3 dnspython
RUN update-ca-certificates 2&>1 > /dev/null

COPY ansible /ansible
COPY cloudformation /cloudformation
COPY scripts/* /usr/local/bin/

RUN get-latest-awscli2