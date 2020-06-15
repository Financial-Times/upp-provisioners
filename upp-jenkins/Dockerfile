FROM ubuntu:18.04

ENV \
  PACKER_VERSION="1.6.0"

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
  && get-latest-awscli2 \
  && get-packer ${PACKER_VERSION}
