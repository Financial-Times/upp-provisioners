FROM alpine:3.5

COPY provision.sh /provision.sh
COPY decom.sh /decom.sh
COPY cloudformation/neo4jhacluster.yaml /neo4jhacluster.yaml

RUN apk --update add bash curl py-pip jq \
    && pip install --upgrade pip awscli

CMD /bin/bash /provision.sh
