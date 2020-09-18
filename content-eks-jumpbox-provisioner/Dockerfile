FROM ubuntu:18.04

COPY cloudformation /cloudformation/
COPY sh/* /usr/local/bin/
COPY config/* /config/

RUN chmod +x /usr/local/bin/*

RUN apt-get update && apt-get install -y \
    less \
    zip \
    curl \
    wget \
    jq \
    vim \
  && rm -rf /var/lib/apt/lists/* \
  && get-latest-awscli2 
