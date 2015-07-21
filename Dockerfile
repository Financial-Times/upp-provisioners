FROM centos

RUN yum -y update
RUN yum -y install python-pip python-virtualenv gcc python-devel

RUN echo "[localhost]" >~/.ansible_hosts
RUN echo '127.0.0.1 ansible_python_interpreter=$VIRTUAL_ENV/bin/python' >>~/.ansible_hosts

#RUN yum -y install python-crypto
#RUN yum -y install PyYAML
#RUN yum -y install libyaml

# Create virtualenv dir
RUN mkdir .venv

# Init virtualenv
RUN virtualenv .venv

# Activate virtual env
RUN . .venv/bin/activate && pip install ansible boto awscli

ADD . /

CMD ./provision.sh

