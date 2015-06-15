#Docker image to provision a cluster

###

```
docker build -t setup .
docker run --env "AWS_SECRET_ACCESS_KEY=xxxxxxx" --env "AWS_ACCESS_KEY_ID=xxxxxxxx" --env "TOKEN_URL=https://discovery.etcd.io/xxxxxx" --env "VAULT_PASS=xxxxxxxx" --env "DEPLOYER_SERVICE_FILE_LOCATION=https://raw.githubusercontent.com/Financial-Times/fleet/master/service-files/deployer.service" setup
```

