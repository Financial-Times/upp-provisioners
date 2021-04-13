FROM alpine:3.6

ENV ANSIBLE_HOSTS=/ansible/hosts

RUN apk --update add python py-pip ansible=2.3.0.0-r1 bash ca-certificates py-mysqldb jq
RUN pip install --upgrade pip boto boto3 dnspython awscli MySQL-python \
 && update-ca-certificates 2&>1 > /dev/null

COPY ansible /ansible
COPY cloudformation /cloudformation
COPY sh/* /usr/local/bin/
