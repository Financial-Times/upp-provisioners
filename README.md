UPP RDS resource
===

RDS provisioning scripts


How To run it
------

Setting up your environment is done by:
* Make sure you have Python and [Virtualenv](https://virtualenv.pypa.io/en/stable/) installed
* check out project
* run
```
$ virtualenv  --no-site-packages -p python2 venv
$ source venv/bin/activate
$ pip install -r requirements.txt
$ deactivate
```
Your environment is now setup to run Ansible using Virtualenv. For more details see http://docs.python-guide.org/en/latest/dev/virtualenvs/.

To run the Ansible script you need to do the following:
* Run `source venv/bin/activate` to activate the Ansible environment
* Run `AWS_SECRET_ACCESS_KEY=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY AWS_ACCESS_KEY_ID=AKIAI44QH8DHBEXAMPLE  ansible-playbook -vvv rdsserver.yml`


Todo
------
1. Move this into repo for all our infrastructure
2. Remove hardcode values
3. Get password from vault
4. Add cloudwatch alarms