FROM coco/k8s-cli-utils

ENV ANSIBLE_VERSION="2.8.3" \
    KUBECTL_VERSION="v1.11.0"

RUN apk --update --no-cache add \
    ca-certificates \
    openssl \
    python3 \
    openssh \
    sshpass \
    git \
    bash \
    curl \
    jq \
  && apk --update add --virtual build-dependencies \
	python3-dev \
    libffi-dev \
    openssl-dev \
    build-base \
  && pip3 install --upgrade pip \
  && pip install cryptography==2.9.2 \
  && pip3 install \
    ansible==${ANSIBLE_VERSION} \
    boto3 \
    awscli \
  && mkdir -p /etc/ansible /ansible \
  && wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \ 
  && mv ./kubectl /usr/local/bin/kubectl \
  && echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts \
  && apk del build-dependencies \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/*

COPY ansible /ansible
COPY cloudformation /cloudformation
COPY scripts/* /

