FROM alpine:3.5

RUN apk --update add bash curl py-pip \
    && pip install --upgrade pip awscli

COPY cloudformation/cloudformation
COPY sh/* /usr/local/bin/
