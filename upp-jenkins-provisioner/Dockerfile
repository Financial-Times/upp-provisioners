FROM ubuntu:24.04

ENV \
  PACKER_VERSION="1.15.1" \
  PACKER_AMAZON_PLUGIN_VERSION="1.8.0"

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
  && get-packer ${PACKER_VERSION} \
  && packer plugins install github.com/hashicorp/amazon ${PACKER_AMAZON_PLUGIN_VERSION}
