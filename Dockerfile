FROM alpine:3.5

WORKDIR /data

COPY requirements.txt /data/requirements.txt

RUN apk add --no-cache --update python bind-tools bash && \
    apk add --no-cache --update --virtual .build-dependencies python-dev build-base libffi-dev openssl-dev py-pip && \
    pip --no-cache-dir install -r /data/requirements.txt && \
    apk del .build-dependencies

COPY cloudformation /data/cloudformation

COPY inventory /data/inventory

COPY ansible.cfg /data/

COPY rdsserver.yml /data/

COPY sh/* /usr/local/bin

CMD ["provision.sh"]
