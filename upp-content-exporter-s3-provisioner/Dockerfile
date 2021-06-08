FROM ubuntu:18.04

COPY scripts/* /usr/local/bin/
COPY config/ /config/

RUN apt-get update && apt-get install -y \
    less \
    zip \
    curl \
    wget \
    jq \
    vim \
  && rm -rf /var/lib/apt/lists/* \
  && chmod -R 755 /usr/local/bin/ \
  && get-latest-awscli2
