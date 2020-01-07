FROM golang:1-alpine

ENV PROJECT=kafka-topic-creator \
    KUBECTL_VERSION="v1.14.0"

RUN apk --update --no-cache add jq

COPY . /${PROJECT}/
WORKDIR /${PROJECT}

RUN wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  apk --update --no-cache add jq

RUN go build -mod=readonly

CMD ./kafka-topic-creator -b $(./kubectl --server "$K8S_API_SERVER" --token "$K8S_TOKEN" --insecure-skip-tls-verify=true get configmaps global-config -o json | jq '.data."kafka.url"')

