FROM alpine:3.12

RUN apk --update add py-pip ansible bash ca-certificates \
 && pip install --upgrade pip boto boto3 \
 && update-ca-certificates 2&>1 > /dev/null

COPY cloudformation /cloudformation
COPY ansible /ansible
COPY sh/* /usr/local/bin/
