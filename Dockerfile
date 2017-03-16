FROM alpine:3.5

COPY ansible /ansible
COPY cloudformation /cloudformation
COPY sh/* /usr/local/bin

ENV ANSIBLE_HOSTS=/ansible/hosts

RUN apk --update add python py-pip ansible bash \
 && pip install --upgrade pip boto boto3
