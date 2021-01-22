FROM ubuntu:18.04

ENV \
  SCEPTRE_VERSION="2.4.0" \
  LC_ALL=C.UTF-8 \
  LANG=C.UTF-8

COPY scripts/* /usr/local/bin/
COPY config/ /config/
COPY lib/ /lib/

RUN apt-get update && apt-get install -y \
    less \
    zip \
    curl \
    wget \
    jq \
    vim \
  && rm -rf /var/lib/apt/lists/* \
  && get-python3 \
  && get-sceptre ${SCEPTRE_VERSION} \
  && get-latest-awscli2
