FROM centos

RUN yum -y update
RUN yum -y install python-pip python-virtualenv gcc

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
RUN . .venv/bin/activate && pip install ansible boto

ADD . /

CMD export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID && export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY && . .venv/bin/activate && $VAULT_PASS > /vault.pass && ansible-playbook -i ~/.ansible_hosts aws_coreos_site.yml --extra-vars "token=$TOKEN_URL" --vault-password-file=/vault.pass 

