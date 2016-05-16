CoCo Tutorial
=============


Goals and overview
------------------

By the time you finish this you will have deployed your own private CoCo cluster into AWS,
figured out how to investigate problems and rectify them. You will *not* yet be able to run the
Universal Publishing stack; that'll come later. Firstly, you'll get a "Hello World" style service running
on your cluster.

At a high level you will:

1. [Set up SSH](#Set-up-SSH)
1. [Create a branch of the services to be run](#Creating-an-environment-branch)
1. [Create a new CoCo cluster](#Create-a-CoCo-cluster)
1. Deploy a new service
1. Decommission the cluster


Set up SSH
----------

1. If you haven't already, generate a pair of SSH keys:
```sh
ssh-keygen
```

1. Edit your ssh config:
```sh
vi ~/.ssh/config
```

1. Add the following lines:
```
Host *tunnel-up.ft.com
  ForwardAgent yes
  User core
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
```

1. Add your SSH keys to the SSH agent:
```sh
ssh-add
```
  This needs to be done [every time the machine boots](http://unix.stackexchange.com/questions/140075/ssh-add-is-not-persistent-between-reboots), on OSX this problem can be avoided by adding them to OSX keychain:

Create a services repository
----------------------------

CoCo needs to know which services you want to deploy, the easiest way to store the services is to have them in a public git repository.

1. Create a public accessible repository. Probably the easiest way to do this is to create a public repo on [GitHub](https://github.com).

1. Create a service roster:

    You will need to create a `services.yml` file, which will contain details of the services you want to run in the cluster.
    Define one service by adding the following:

    ```yaml
    services:
    - name: my-app@.service
      count: 2
    ```

    In the UPP CoCo stack each service typically has a main `@.service` which contains details of the service and a
    second `-sidekick@.service` file which is used to monitor the service. For the purpose of this tutorial we'll
    just have the main service definition.

1. Create the service definitions

  All services run as systemd like entities through (fleet)[https://coreos.com/fleet/docs/latest/launching-containers-fleet.html].

  Create a file called `my-app@.service` and add the following

  ```
  [Unit]
  Description=MyApp
  After=docker.service
  Requires=docker.service

  [Service]
  TimeoutStartSec=0
  ExecStartPre=-/usr/bin/docker kill busybox1
  ExecStartPre=-/usr/bin/docker rm busybox1
  ExecStartPre=/usr/bin/docker pull busybox
  ExecStart=/usr/bin/docker run --name busybox1 busybox /bin/sh -c "trap 'exit 0' INT TERM; while true; do echo Hello World; sleep 3; done"
  ExecStop=/usr/bin/docker stop busybox1
  ```

  The `[Unit]` section lets you define dependencies, in this particular case we want to make sure docker is available before we try to use it!

  The `[Service]` section is the nuts and bolts of how you launch your service. Essentially the `ExecStartPre` get run before the main `ExecStart` and `ExecStop` runs when you want to stop the service.

###A bit more detail

  You'll notice that in the `ExecStartPre` section we tidy up anything left over from a previously running instance of the server. The `ExecStartPre=-/usr/bin/docker kill busybox1` and `ExecStartPre=-/usr/bin/docker rm busybox1` kill the service if it is running and remove the container.

  Following this we get the latest 'busybox' docker image using `ExecStartPre=/usr/bin/docker pull busybox`.

  The service is finally launched via `ExecStart=/usr/bin/docker run --name busybox1 busybox /bin/sh -c "trap 'exit 0' INT TERM; while true; do echo Hello World; sleep 3; done"` which will simply print "Hello World" every three seconds unless it receives a term signal.

  See [Getting started with Systemd](https://coreos.com/docs/launching-containers/launching/getting-started-with-systemd/) for a more thorough explanation of these and other directives.

1. Commit and push you recent additions


Create the CoCo cluster
---------------------

There are a set of instructions in the [main README file](/README.md).

1. Set up a local instance of docker by downloading and installing [Docker Toolbox](https://www.docker.com/products/docker-toolbox).
The CoCo Provisioner is a docker image, so ensure you have docker installed and are able to carry out
simple docker commands.

    *NB. If you feel like it there is now a 'native' docker available for
Windows and OSX rather than the toolbox, see [Beta programme](https://beta.docker.com/docs/features-overview/) for details.*

1. Clone this repository:

        bash
        git clone git@github.com:Financial-Times/coco-provisioner.git

1. Build this docker image:

        bash
        eval "$(docker-machine env default)" # if you are using VM-based docker
        docker build .

1. Set configuration parameters (CoCo Provisioner needs to know a few details):

    |          ENV VAR               |      Comments                           |                Suggested / default value             |
    | ------------------------------ | --------------------------------------- | ---------------------------------------------------- |
    | `SERVICES_DEFINITION_ROOT_URI` | Service definitions                     |                                                      |
    | `TOKEN_URL`                    | The etcd token identifying this cluster | `curl -s https://discovery.etcd.io/new?size=5`       |
    | `AWS_MONITOR_TEST_UUID`        | TBD                                     | `curl -s https://www.uuidgenerator.net/api/version4` |
    | `COCO_MONITOR_TEST_UUID`       | TBD                                     | `curl -s https://www.uuidgenerator.net/api/version4` |
    | `BRIDGING_MESSAGE_QUEUE_PROXY` | Optional                                |                                                      |
    | `VAULT_PASS`                   | TBD                                     | See LastPass.                                        |
    | `AWS_SECRET_ACCESS_KEY`        | TBD                                     |                                                      |
    | `AWS_ACCESS_KEY_ID`            | TBD                                     |                                                      |
    | `ENVIRONMENT_TAG`              | TBD                                     |                                                      |
    | `BINARY_WRITER_BUCKET`         | TBD                                     |                                                      |

1. Run the provisioner:

    (NB. You may need to run this as root, if this is the case `sudo` first.)
  ```bash
  docker run \
      --env "VAULT_PASS=$VAULT_PASS" \
      --env "TOKEN_URL=$TOKEN_URL" \
      --env "SERVICES_DEFINITION_ROOT_URI=$SERVICES_DEFINITION_ROOT_URI" \
      --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
      --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
      --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" coco-provisioner
  ```

  There are some additional parameters which can be passed, however we won't need them for the moment since they configure CoCo's settings so it can access Kafka etc.

1. All being well you will now have a CoCo cluster. It is unlikely to be healthy when it starts.

    1. To verify that the cluster has been started, go to the [AWS console](http://awslogin.internal.ft.com/) and go to the
eu-west-1 (Ireland) view of running EC2 instances.

    1. In the filter field enter the value of the `ENVIRONMENT_TAG` used to create the cluster.

    *NB. Wait for all your servers to be in a running state before you move on!*



1. Creating the cluster should have registered some new host names with our DNS provider:

  | _ENVIRONMENT_TAG_-up.ft.com        | HTTP endpoint for your cluster       |
  | ---------------------------------- | -------------------------------------|
  | _ENVIRONMENT_TAG_-tunnel-up.ft.com | Allowed you to SSH into your cluster |

  Check you can resolve these hosts by running a `dig` or `nslookup`.
