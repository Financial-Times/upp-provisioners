#Playbook to provision nodes for coreos cluster

###Requirements

 - python2 + pip + virtualenv
 - pip packages: ansible, boto
 - ansible hosts file:

```bash
(.venv)coreos(master)/cat ~/.ansible_hosts 
[localhost]
127.0.0.1 ansible_python_interpreter=$VIRTUAL_ENV/bin/python
```

###Set up environment

```bash
# Create virtualenv dir
mkdir .venv

# Init virtualenv
virtualenv .venv

# Activate virtual env
. .venv/bin/activate

# Install pip dependencies
pip install ansible boto
```

###Running playbook

 - export AWS secret and access keys:

```bash
export AWS_SECRET_ACCESS_KEY=<secret key>
export AWS_ACCESS_KEY_ID=<access key>
```

 - run playbook: `ansible-playbook aws_coreos_site.yml --extra-vars "token=https://discovery.etcd.io/<id>"`

