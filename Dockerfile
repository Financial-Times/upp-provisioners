FROM centos

RUN yum -y update && yum -y install python-pip python-virtualenv gcc python-devel
RUN echo "[localhost]" >~/.ansible_hosts && echo '127.0.0.1 ansible_python_interpreter=$VIRTUAL_ENV/bin/python' >>~/.ansible_hosts

# Create virtualenv dir
RUN mkdir .venv && virtualenv .venv && . .venv/bin/activate && pip install ansible boto awscli

ADD provision.sh /
ADD ansible/ /ansible

CMD ./provision.sh

