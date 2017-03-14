FROM alpine:3.5

# ADD *.sh /
# ADD ansible/ /ansible
# ADD cloudformation /
#
# RUN echo "[localhost]" > ~/.ansible_hosts \
#  && echo '127.0.0.1 ansible_python_interpreter=/.venv/bin/python' >> ~/.ansible_hosts \
#  && apk --update add py-pip py-virtualenv gcc python-dev libffi-dev openssl-dev build-base bash jq util-linux curl \
#  && mkdir .venv \
#  && virtualenv .venv \
#  && . .venv/bin/activate \
#  && pip install ansible==2.0.2.0 boto awscli
#
# CMD /bin/bash provision.sh

ADD ansible /ansible
ADD cloudformation /cloudformation

RUN apk --update add python py-pip ansible bash \
 && pip install --upgrade pip boto3
