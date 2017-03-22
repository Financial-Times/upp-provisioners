from fabric.api import env, local, run, task

env.user = 'core'

@task
def test():
    local('echo "Testing SSH connection."')
    run('uname -r')

@task
def kick_ingestion(pghost,
                   pguser,
                   pgpassword,
                   dbname,
                   aws_access_key,
                   aws_secret_key,
                   aws_region,
                   loader_version="latest"):
    local('echo "Running ingestion."')
    run("docker run -it --rm --name rds-loader " \
    	"-e 'PGHOST=%s' " \
    	"-e 'PGUSER=%s' " \
    	"-e 'PGPASSWORD=%s' " \
    	"-e 'PGDATABASE=%s' " \
    	"-e 'AWS_ACCESS_KEY_ID=%s' " \
    	"-e 'AWS_SECRET_ACCESS_KEY=%s' " \
    	"-e 'AWS_DEFAULT_REGION=%s' " \
    	"coco/up-rds-loader:%s" %
    	   (pghost, pguser, pgpassword, dbname,
    	   	aws_access_key, aws_secret_key, aws_region,
    	   	loader_version))

@task
def remove_etcd_values():
    run("etcdctl rm --recursive /ft/config/factset-rds")

@task
def set_etcd_values(pghost,
                    pgport,
                    pguser,
                    pgpassword,
                    dbname):
    run("etcdctl set /ft/config/factset-rds/host %s" % pghost)
    run("etcdctl set /ft/config/factset-rds/port %s" % pgport)
    run("etcdctl set /ft/config/factset-rds/user %s" % pguser)
    run("etcdctl set /ft/config/factset-rds/password %s" % pgpassword)
    run("etcdctl set /ft/config/factset-rds/dbname %s" % dbname)
