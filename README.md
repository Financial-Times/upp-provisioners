#Docker image to provision a cluster

###

```
docker build -t setup .
docker run --env "TOKEN_URL=https://discovery.etcd.io/xxxxxx" --env "VAULT_PASS=xxxxxxxx" setup
```
or if you want to override the AWS credentials
```
docker run --env "TOKEN_URL=https://discovery.etcd.io/xxxxxx" --env "VAULT_PASS=xxxxxxxx" --env "AWS_SECRET_ACCESS_KEY=xxxxxxx" --env "AWS_ACCESS_KEY_ID=xxxxxxxx" setup
```

