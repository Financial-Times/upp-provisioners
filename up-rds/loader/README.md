UPP RDS data loader
===

RDS loading tool


How To build it
------

To build the tool as Docker image run  -

```
$ docker build -t coco/up-rds-loader .
```

or you can pull the image by running

```
$ docker pull coco/up-rds-loader
```

The image needs the following environment variables passed to it -

* PGHOST - The hostname of the database
* PGUSER - The username to access the database
* PGPASSWORD - The password for the user to access the database
* PGDATABASE - The database name
* AWS_ACCESS_KEY_ID - The AWS access key with permission to download the facset file
* AWS_SECRET_ACCESS_KEY - The AWS secret access key for the above key
* AWS_DEFAULT_REGION - The region the S3 bucket is in

These are also the same environment variables you'll need set if you just wanted to run the script `rds-load`.

To run Docker image it is just:

```
$ docker run --rm --name rds-loader \
-e "PGHOST=rds.somewhere.in.amazon.com"
-e "PGUSER=user"
-e "PGPASSWORD=changeit"
-e "PGDATABASE=people"
-e "AWS_ACCESS_KEY_ID=AKIAI44QH8DHBEXAMPLE"
-e "AWS_SECRET_ACCESS_KEY=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY"
-e "AWS_DEFAULT_REGION=eu-west-1"
coco/rds-loader
```

How To run the database locally
------

If you want to run the database locally with all the data loaded you need [Docker Compose](https://docs.docker.com/compose/overview/). You will need also the AWS access key and AWS secret key to access the bucket with the factset data.

* Create a file in this directory called `.env` with the following content:
```
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
```
* The run:
```
$ docker-compose -f docker-compose.yml up
```

This will bring up a local Postgres  database and will populate it with all the facset data.

If you just want to run Postgres locally with no data, then run the following:
```
$ docker-compose -f dc-postgres.yml up
```
