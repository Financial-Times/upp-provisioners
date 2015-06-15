#Docker image to provision a cluster

###

```
docker build -t setup .
docker run --env "TOKEN_URL=https://discovery.etcd.io/xxxxxx" --env "VAULT_PASS=xxxxxxxx" --env "DEPLOYER_SERVICE_FILE_LOCATION=https://raw.githubusercontent.com/Financial-Times/fleet/master/service-files/deployer.service" setup
```
or if you want to override the AWS credentials
```
docker run --env "TOKEN_URL=https://discovery.etcd.io/xxxxxx" --env "VAULT_PASS=xxxxxxxx" --env "DEPLOYER_SERVICE_FILE_LOCATION=https://raw.githubusercontent.com/Financial-Times/fleet/master/service-files/deployer.service" --env "AWS_SECRET_ACCESS_KEY=xxxxxxx" --env "AWS_ACCESS_KEY_ID=xxxxxxxx" setup
```

