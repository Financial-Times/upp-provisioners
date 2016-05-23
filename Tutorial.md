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
1. [Create a service repository](#Creating-a-service-repository)
1. [Create a CoCo cluster](#Create-a-CoCo-cluster)
1. [Check the deployer](#Check-the-deployer)
1. [View service logs](#View-service-logs)


Set up SSH
----------

1. If you haven't already, generate a pair of SSH keys:

        sh
        ssh-keygen

1. Edit your ssh config:

        sh
        vi ~/.ssh/config

1. Add the following lines:

        Host *tunnel-up.ft.com
            ForwardAgent yes
            User core
            StrictHostKeyChecking no
            UserKnownHostsFile /dev/null

1. Add your SSH keys to the SSH agent:

        sh
        ssh-add

    NB. This needs to be done [every time the machine boots](http://unix.stackexchange.com/questions/140075/ssh-add-is-not-persistent-between-reboots).
        On OSX this problem can be avoided by adding them to the OSX keychain.

Create a service repository
---------------------------

CoCo needs to know which services you want to deploy, the easiest way to store the services is to have them in a public git repository.

1. Create a public accessible repository. Probably the easiest way to do this is to create a public repo on [GitHub](https://github.com).

1. Create a service roster:
    You will need to create a `services.yaml` file, which will contain details of the services you want to run in the cluster.
    Define one service by adding the following:

  ```yaml
  services:
  - name: my-app@.service
    count: 1
  - name: tunnel-registrator.service
    uri: https://raw.githubusercontent.com/Financial-Times/up-service-files/master/tunnel-registrator.service
  ```
    The first service `name: my-app@.service` is going to be our service, and for now just one instance of it is needed.

    The second service `name: tunnel-registrator.service` makes it easier to SSH into the cluster. The service definition will be loaded from the URI that is specified.

    In the UPP CoCo stack each service typically has a main `@.service` which contains details of the service and a
    second `-sidekick@.service` file which is used to monitor the service. For the purpose of this tutorial we'll
    just have the main service definition.

1. Create the service definitions

  All services run as systemd like entities through (fleet)[https://coreos.com/fleet/docs/latest/launching-containers-fleet.html].

  Create a file called `my-app@.service` and add the following
  ```systemd
  [Unit]
  Description=MyApp
  After=docker.service
  Requires=docker.service

  [Service]
  TimeoutStartSec=0
  ExecStartPre=-/usr/bin/docker kill %p-%i
  ExecStartPre=-/usr/bin/docker rm %p-%i
  ExecStartPre=/usr/bin/docker pull busybox
  ExecStart=/usr/bin/docker run --name %p-%i busybox /bin/sh -c "trap 'exit 0' INT TERM; while true; do echo Hello World; sleep 3; done"
  ExecStop=/usr/bin/docker stop %p-%i
  ```

  The `[Unit]` section lets you define dependencies, in this particular case we want to make sure docker is available before we try to use it!

  The `[Service]` section is the nuts and bolts of how you launch your service. Essentially the `ExecStartPre` get run before the main `ExecStart` and `ExecStop` runs when you want to stop the service.

  You'll notice that in the `ExecStartPre` section we tidy up anything left over from a previously running instance of the server. The `ExecStartPre=-/usr/bin/docker kill %p-%i` and `ExecStartPre=-/usr/bin/docker rm  %p-%i` kill the container and remove the container. The `%p-%i` value is a combination of the service name and instance number.

  Following this we get the latest 'busybox' docker image using `ExecStartPre=/usr/bin/docker pull busybox`.

  The service is finally launched via `ExecStart=/usr/bin/docker run --name busybox1 busybox /bin/sh -c "trap 'exit 0' INT TERM; while true; do echo Hello World; sleep 3; done"` which will simply print "Hello World" every three seconds unless it receives a term signal.

  See [Getting started with Systemd](https://coreos.com/docs/launching-containers/launching/getting-started-with-systemd/) for a more thorough explanation of these and other directives.

1. Commit and push you recent additions


Create a CoCo cluster
---------------------

There are a set of instructions in the [main README file](/README.md) which may be of use reading.

1. Set up a local instance of docker by downloading and installing [Docker Toolbox](https://www.docker.com/products/docker-toolbox).
The CoCo Provisioner is a docker image, so ensure you have docker installed and are able to carry out
simple docker commands.

  *NB. If you feel like it, there is now a 'native' docker available for
Windows and OSX rather than the toolbox, see [Beta programme](https://beta.docker.com/docs/features-overview/) for details.*

1. Clone this repository:
```bash
git clone git@github.com:Financial-Times/coco-provisioner.git
```

1. Build this docker image:
```bash
cd coco-provisioner
eval "$(docker-machine env default)" # if you are using VM-based docker
docker build .
```

1. Set configuration parameters:


  |          ENV VAR               |      Comments                             |                 Suggested / default value             |
  | ------------------------------ | ----------------------------------------- | ----------------------------------------------------- |
  | `ENVIRONMENT_TAG`              | An identifier for YOUR cluster            |
  | `SERVICES_DEFINITION_ROOT_URI` | Service definitions                       |                                                       |
  | `TOKEN_URL`                    | The etcd token identifying this cluster   | `curl -s https://discovery.etcd.io/new?size=5`        |
  | `VAULT_PASS`                   | The password to unlock the ansiable vault | Ask a friend about this                               |
  | `AWS_SECRET_ACCESS_KEY`        | As its name implies                       | Ask a friend about this                               |
  | `AWS_ACCESS_KEY_ID`            | As its name implies                       | Ask a friend about this                               |

  *Note*
  The value for 'SERVICES_DEFINITION_ROOT_URI' should point at the repository [created earlier](#Create-a-services-repository). It takes the form of `https://raw.githubusercontent.com/Owner/Repo/branch/`, for example the UPP stack is located at 'https://raw.githubusercontent.com/Financial-Times/up-service-files/master/'

  When you (re)create a cluster, always make sure that the token value used by the TOKEN_URL is different.

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

1. All being well you will now have a CoCo cluster.

    1. To verify that the cluster has been started, go to the [AWS console](http://awslogin.internal.ft.com/) and go to the
eu-west-1 (Ireland) view of running EC2 instances.

    1. In the filter field enter the value of the `ENVIRONMENT_TAG` used to create the cluster.
    *NB. Wait for all your servers to be in a running state before you move on!*

1. Creating the cluster should have registered some new host names with our DNS provider:


  | _ENVIRONMENT_TAG_-up.ft.com        | HTTP endpoint for your cluster       |
  | ---------------------------------- | -------------------------------------|
  | _ENVIRONMENT_TAG_-tunnel-up.ft.com | Allowed you to SSH into your cluster |

  Check you can resolve these hosts by running a `dig` or `nslookup`.

Check the deployer
------------------
The deployer is responsible for setting the desired state for the cluster, which is defined by the services.yml file. If this is deploying or barfing it's unlikely that your cluster is healthy.

1. SSH onto the cluster:
```bash
ssh $ENVIRONMENT_TAG-tunnel-up.ft.com
```
1. See what's running:
```bash
$ fleetctl list-units
UNIT                        MACHINE                    ACTIVE  SUB
deployer.service            57efbeaf.../172.24.86.114  active  running
my-app@1.service            b15dff35.../172.24.11.41   active  running
tunnel-registrator.service  b74cf51a.../172.24.147.242 active  exited
```
The deployer checks the services.yaml and monitors it for changes. When a change occurs, for example the number of services are increased, the deployer acts on the change.

1. Tail the deployer log:
```bash
fleetctl journal --lines=100 deployer
```
All being well, the deployer will just work, but it has been known to go [a bit Pete Tong](https://en.wikipedia.org/wiki/Pete_Tong) so do check it.

1. Tail your service log:
```bash
fleetctl journal -f my-app@1.service
-- Logs begin at Mon 2016-05-16 13:59:54 UTC. --
May 16 14:45:56 ip-172-24-11-41.eu-west-1.compute.internal docker[1134]: Hello World
May 16 14:45:59 ip-172-24-11-41.eu-west-1.compute.internal docker[1134]: Hello World
May 16 14:46:02 ip-172-24-11-41.eu-west-1.compute.internal docker[1134]: Hello World
May 16 14:46:05 ip-172-24-11-41.eu-west-1.compute.internal docker[1134]: Hello World
May 16 14:46:08 ip-172-24-11-41.eu-west-1.compute.internal docker[1134]: Hello World
```
Every three seconds you should see a new line being written. Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop tailing the log.

1. Increase the number of instances running.
  1. Modify the services.yaml so that it specifies two instances, as shown in this extract:
  ```yaml
  - name: my-app@.service
    count: 2
  ```

  1. Commit and push the changes.

  1. Tail the deployer to see the number of services increase using :
  ```bash
  fleetctl journal -f deployer.service
  ```
  Once the change has been detected a second instance of the service should start.

  1. Check the running units using `fleetctl list-units`

  1. Check the logs of one of the new instances: `fleetctl journal -f my-app@2.service`

Summary
-------
In the tutorial you have created a new service to deploy, build a new cluster and deployed the service to the cluster. This means you have become familiar with some back CoCo concepts and fleet/docker commands.
