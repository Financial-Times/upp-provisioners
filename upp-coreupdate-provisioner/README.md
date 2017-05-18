# UPP CoreUpdate Provisioning - manual steps

High level overview:

 * Create a CoreOS EC2 instance
 * Add CoreUpdate license to the instance
 * Configure the Postgres service
 * Enable Google OAuth
 * Configure the CoreUpdate service
 * Initialise CoreUpdate and link to public upstream channels
 * Create an Application Load Balancer
 * Create a DNS CNAME record

Documentation is provided by CoreOS here:  
https://coreos.com/products/coreupdate/docs/latest/on-premises-deployment.html

However, note that a number of the steps in the CoreOS documentation are either inaccurate or missing.  
This readme covers all the steps required.

Please note that we plan to create proper provisioning playbooks with Ansible & CloudFormation.  
This readme will be updated / removed once that's complete.

## Create a CoreOS EC2 instance

Provision an EC2 instance running the latest CoreOS AMI.  
We're currently running a `t2.small` instance for UPP. Because we're not downloading the CoreOS images directly to the CoreUpdate box, we've not needed to provision any additional storage.

For instance userdata, copy `cloud-config.yml` to enable SSH access for UPP users.

The instance will need to be in a public subnet in order for CoCo clusters to connect.  
[NOTE - is this true? The ALB we create should be public, but there's no reason the instance itself has to be public. Let's double check.]  
Add the instance into the Web and Resources security groups.

## Add CoreUpdate license to the instance

Log in to https://account.coreos.com.  
On the Overview page, you will need to copy the Pull Secret and save it on the CoreOS instance.

On the CoreOS instance as the `core` user, run the following command to create the .docker directory:
```
mkdir -p /home/core/.docker
sudo mkdir -p /root/.docker
```

Create the following two files:
```
/home/core/.docker/config.json
/root/.docker/config.json
```

The contents should be the Pull Secret copied from the CoreOS account page.

Run the following command to confirm that the Pull Secret has been configured correctly:
```
docker pull quay.io/coreos/coreupdate
```

## Configure the Postgres service

Copy the `postgres.service` file to the following location:
```
/etc/systemd/system/postgres.service
```

Run the following commands to start and enable the service on boot:
```
sudo systemctl start postgres.service 
sudo systemctl enable postgres.service
journalctl -fu postgres.service
```

Review the log output, and confirm that the service has started correctly.

Run the following commands to create the `coreos` user and the `coreupdate` database.  
Replace `supersecretpassword` with an actual super secret password. :)
```
docker run --net="host" postgres:9.4 psql -h localhost -U postgres --command "CREATE USER coreos WITH SUPERUSER"
docker run --net="host" postgres:9.4 psql -h localhost -U postgres --command "ALTER USER coreos WITH PASSWORD 'supersecretpassword';"
docker run --net="host" postgres:9.4 psql -h localhost -U postgres --command "CREATE DATABASE coreupdate OWNER coreos;"
```

## Configure Google OAuth

Log into https://console.developers.google.com.  
Switch your user to `upp-google-oauth@ft.com` - the credentials are in LastPass.

Under 'Credentials', select 'Create OAuth Client ID':  
![google-oauth](/upp-coreupdate-provisioner/images/google-oauth.png?raw=true "Google OAuth"))

You will need the `Client ID` and `Client Secret` when configuring CoreUpdate.

Add a new `Authorised Redirect URL` - as an example, our current URL is:
```
https://upp-coreupdate.in.ft.com/admin/v1/oauth/login
```

Replace your hostname as appropriate.

## Configure the CoreUpdate service

Run the following command to create the CoreUpdate config directory:
```
mkdir -p /etc/coreupdate
```

Copy the `config.yaml` file to the following location:
```
/etc/coreupdate/config.yaml
```

Update the following parameters as appropriate:
```
BASE_URL
SESSION_SECRET
GOOGLE_OAUTH_CLIENT_ID
GOOGLE_OAUTH_CLIENT_SECRET
GOOGLE_OAUTH_REDIRECT_URL
DB_URL
```

Copy the `coreupdate@.service` file to the following location:
```
/etc/systemd/system/coreupdate@.service
```

Run the following commands to start and enable the service on boot:
```
sudo systemctl start coreupdate@1.service
sudo systemctl enable coreupdate@1.service
journalctl -fu coreupdate@1.service
```

Review the log output, and confirm that the service has started correctly.

## Initialise CoreUpdate and link to public upstream channels

Run the following commands to download and extract the `updateservicectl` utility:
```
cd ~
wget https://github.com/coreos/updateservicectl/releases/download/v1.3.6/updateservicectl-v1.3.6-linux-amd64.tar.gz
tar -xzvf updateservicectl-v1.3.6-linux-amd64.tar.gz
cd updateservicectl-v1.3.6-linux-amd64
```

Run the following command to initialise the database:
```
./updateservicectl --server=http://localhost:8000 database init
```

Note that this command will output an API key.  
You will need to substitute this API key into the following commands. 

Run the following commands to create your user, set up the CoreOS applicaton, and configure the upstream channels:
```
./updateservicectl --server=http://localhost:8000 --user=admin --key=apikeyfrompreviouscommand admin-user create your.name@ft.com
./updateservicectl --server=http://localhost:8000 --user=admin --key=apikeyfrompreviouscommand app create --label=CoreOS --app-id=e96281a6-d1af-4bde-9a0a-97b76e56dc57
./updateservicectl --server=http://localhost:8000 --user=admin --key=apikeyfrompreviouscommand upstream create --label="Public CoreOS" --url="https://public.update.core-os.net"
```

Note that the `app-id` must be set exactly as listed here for CoreOS updates to work correctly.

## Create an Application Load Balancer

In AWS, create an ALB.
The ALB should:
- be in the same VPC / subnets / AZ / security groups as your CoreUpdate instance
- listen on HTTPS, using the appropriate FT wildcard certificate
- route traffic to port 8000 on your instance
- healthcheck path should be `/cp/login` , and the healthy/unhealthy thresholds should be set to 2.

## Create a DNS CNAME record

Create your CNAME in Dyn.  
This will need to match the `BASE_URL` configured earlier in the CoreUpdate `config.yaml` file.

## All done!

You should now be able to log into the CoreUpdate dashboard.

## Things to do

- Proper provisioning playbooks
- Monitoring / alerting
- High availability / multi AZ
