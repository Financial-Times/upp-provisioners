FROM python:3.8-slim

ENV ANSIBLE_HOSTS=/ansible/hosts

RUN apt-get update \
 && apt-get install -y --no-install-recommends bash ca-certificates \
 && pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir ansible==2.9.27 boto boto3 \
 && update-ca-certificates >/dev/null 2>&1 \
 && rm -rf /var/lib/apt/lists/*

COPY ansible /ansible
COPY cloudformation /cloudformation
COPY sh/* /usr/local/bin/
