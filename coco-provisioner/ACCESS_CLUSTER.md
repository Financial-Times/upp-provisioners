# ACCESS_CLUSTER

_... set up your dev env so you can run typical commands to view and investigate a cluster ..._

Note: you must be a coco admin to do this!

*You will need to have [set up your SSH access](/SSH_README.md/)*.

        # ... if DYN address has been set up ...
        export FLEETCTL_TUNNEL=$ENVIRONMENT_TAG-tunnel-up.ft.com

        # ... if DYN address not set up ...
        export FLEETCTL_TUNNEL=<PUBLIC IP OF ANY EC2 INSTANCE IN CLUSTER>

