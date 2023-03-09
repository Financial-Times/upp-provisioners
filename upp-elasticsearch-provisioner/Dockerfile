FROM ubuntu:22.04

ENV ANSIBLE_HOSTS=/ansible/hosts

RUN apt-get update
RUN apt-get -y install ansible ca-certificates jq zip curl
RUN update-ca-certificates 2&>1 > /dev/null

COPY sh/* /usr/local/bin/
RUN chmod -R 755 /usr/local/bin/
RUN get-latest-awscli2

COPY ansible /ansible
COPY cloudformation /cloudformation
