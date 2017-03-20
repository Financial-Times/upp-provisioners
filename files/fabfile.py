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
