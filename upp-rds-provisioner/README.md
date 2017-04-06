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

The variables it takes are:
* cluster - e.g. `pub-semantic`
* environment_type - e.g `t` or `p`
* cluster_sg - The security group the machines that will connect to the RDS instance are in

To run the Ansible script you need to do the following:
* Run `source venv/bin/activate` to activate the Ansible environment
* Run `AWS_SECRET_ACCESS_KEY=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY AWS_ACCESS_KEY_ID=AKIAI44QH8DHBEXAMPLE  ansible-playbook -vvv rdsserver.yml --extra-vars "cluster=pub-semantic environment_type=t cluster_sg=sg-10101"`

The other option is to run the Docker container:
```
$ docker run --rm -e "CLUSTER=<cluster>" -e "ENVIRONMENT_TYPE=<t or p>" -e "CLUSTER_SG=<the security group for the EC2 instances>" -e "VAULT_PASS=<password to unlock the valut>" coco/upp-rds-provisioner:latest
```

Connecting to the RDS instance
------

If you need to connect up the RDS instance, you need to create an `ssh` tunnel forwarding your connection. So you need to run:

```
ssh -A -L 5432:<CLUSTER>-factset-rds-up.in.ft.com:5432 core@<CLUSTER>-tunnel-up.ft.com
```

Then you can connect your Postgres client to `localhost:5432`. Example:

```
psql -h localhost -p 5432 -U <DB_USERNAME> Factset
```

An alternative to using `psql` is to use [pgAdmin](https://www.pgadmin.org/).

Todo
------
1. Move this into repo for all our infrastructure
2. Add cloudwatch alarms
3. Implement lower environment teardown over weekends and recreate on mondays
