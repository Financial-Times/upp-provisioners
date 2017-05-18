# UPP CoreUpdate Provisioning - manual steps

High level overview:

 * Create a CoreOS EC2 instance
 * Add CoreUpdate license to the instance
 * Configure the Postgres service
 * Enable Google OAuth
 * Configure the CoreUpdate service
 * Initialise CoreUpdate to link to the public upstream
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
sudo systemctl status postgres.service
```

Review the status output, and confirm that the service has started correctly.

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
[IMAGE]

## Configure the CoreUpdate service

Run the following command to create the CoreUpdate config directory:
```
mkdir -p /etc/coreupdate
```

