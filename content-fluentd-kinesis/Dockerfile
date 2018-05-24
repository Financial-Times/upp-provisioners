FROM alpine:3.7

ENV ANSIBLE_HOSTS=/ansible/hosts

RUN apk --update add python py-pip ansible bash ca-certificates
RUN pip install --upgrade pip boto boto3 awscli \
      && update-ca-certificates 2&>1 > /dev/null

COPY ansible /ansible
COPY cloudformation /cloudformation
COPY sh/* /usr/local/bin/
