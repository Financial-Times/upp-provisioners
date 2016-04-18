# SSH_README

_... set up your dev env so you can spin up a cluster, or communicate with an existing one._


# Generating RSA key pair


Coco cluster authenticates users based on RSA key. To access Coco cluster first time you need to first generate RSA key pair and push the public key into [authorized_keys file in up-ssh-keys project](https://github.com/Financial-Times/up-ssh-keys/blob/master/authorized_keys).


The following command creates a key pair coco_cluster/coco_cluster.pub in current working directory.

``` 
$ ssh-keygen -t rsa -f ~/.ssh/coco_cluster 
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in coco_cluster.
Your public key has been saved in coco_cluster.pub.
The key fingerprint is:
25:d5:8b:e5:0c:dc:28:f4:23:30:59:80:49:d7:1f:be jussi@BigMac
The key's randomart image is:
+--[ RSA 2048]----+
|   ..o=*o..+     |
|    o..ooo= +    |
|        o++B .   |
|         ++.+    |
|        S  .     |
|          E      |
|                 |
|                 |
|                 |
+-----------------+
```

## Deploying new key

 1. Update [authorized_keys file](https://github.com/Financial-Times/up-ssh-keys/blob/master/authorized_keys)
 2. Check the hash of the authorized_keys file ``` sha512sum authorized_keys ```
 3. Add hash value into file [authorized_keys.sha512](https://github.com/Financial-Times/up-ssh-keys/blob/master/authorized_keys.sha512)
 4. Authorized_keys file will be automatically deployed by [authorized_keys.service](https://github.com/Financial-Times/coco-provisioner/blob/master/ansible/userdata/default_instance_user_data.yaml#L21) that runs on cluster nodes



# Add key to keyring for fleetctl utility

Create an ssh keyring so that our fleet entry host can pass on keys to other cluster nodes
```
eval $(ssh-agent)
ssh-add ~/.ssh/coco_cluster
ssh-add -l # verify your key has been added to the key-ring
```

# Accessing Coco cluster over VPN

SSH access to Coco cluster nodes is controlled by Fleet Security Group. Security group only allows access from [whitelisted IP addresses](https://github.com/Financial-Times/coco-provisioner/blob/master/ansible/aws_coreos_site.yml#L57), such as 82.136.1.214/32 which is OSB outbound IP address.

When connected to VPN your computer's default route to the internet is the local gateway. For this reason the IP address used to connect to Coco cluster does not match whitelisted IP addresses and therefore connection is blocked by Fleet Security Group. 

To workaround this issue we can route all traffic via VPN tunnel interface. By changing the default route your computer will access Coco cluster using one of the whitelisted IP addresses.

## Changing default route

Before changing the default route you need to open VPN connection. Fiddling with routing table may cause your computer to stop talking to the internet. This may happen if you mistype the routing command. If it happens you can restore the routing table to orginal state by re-establishing VPN connection.

### Linux

Linux users can either manually change default route or alternatively use helper script [coco-provisiner/ssh-tun0](https://github.com/Financial-Times/coco-provisioner/blob/master/ssh-tun0) that alters the routing table and establishes SSH session to given host.

##### ssh-tun0 script

Here is example how to use [ssh-tun script](https://github.com/Financial-Times/coco-provisioner/blob/master/ssh-tun0)  to connect to / disconnect from CoreOS cluster.

```
# CONNECTING
$ coco-provisioner/ssh-tun0 core@xp-tunnel-up.ft.com

Setting sudo prefix /usr/bin/sudo for user jussi
Resolving IP for hostname xp-tunnel-up.ft.com
ssh server host xp-tunnel-up.ft.com has IP 52.50.72.70
Found active VPN interface tun0
Adding route 52.50.72.70/32 dev tun0
Route 52.50.72.70/32 dev tun0 successfully added
Last login: Mon Apr 18 08:15:37 2016 from 172.24.121.215
CoreOS alpha (1010.1.0)
This enviroment is tagged as xp and is cluster https://discovery.etcd.io/b9b5d08c15f6365084a21dc3e0791865
core@ip-172-24-121-215 ~ $ 

# DISCONNECTING
core@ip-172-24-121-215 ~ $ exit
logout

Connection to 52.50.72.70 closed.
Do you want to remove routing table record 52.50.72.70/32 dev tun0? [y/n]: y
Route 52.50.72.70/32 dev tun0 successfully deleted
```

##### _Changing default route manually..._

##### Discovering VPN interface IP address

 1. Open Terminal and run command ``` netstat -i ```
 2. Find interface with id _tun_ on the list. In the following example command output VPN interface name is _tun0_

```
Kernel Interface table
Iface   MTU Met   RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
docker0    1500 0         0      0      0 0             0      0      0      0 BMU
lo        65536 0       457      0      0 0           457      0      0      0 LRU
tun0       1400 0        11      0      0 0            11      0      0      0 MOPRU
wlan0      1500 0      9620      0      0 0           268      0      0      0 BMRU
```

##### Changing default route

 1. Delete existing default route ``` sudo ip route del default ```
 2. Add new default route via tun0 interface ``` sudo ip route add default dev tun0 ```



### Windows

##### Discovering VPN interface IP address 

 1. Go to _Network and Sharing_ settings
 2. Click _Connections: Junos Pulse_
 3. Click _Details..._ button
 4. interface IP is shown in _IPv4 Address_ field. Address starts with 10.115.x.x when connecting to UK VPN access point

##### Changing default route
The following command example assumes VPN interface IP address is 10.115.190.152

Open Command Prompt and run the following command to change default route.

``` route change 0.0.0.0 mask 0.0.0.0 10.115.190.152 ```

Replace 10.115.190.152 with correct VPN interface IP address.

### Mac

##### Discovering VPN interface IP address 
Mac users please update instructions

##### Changing default route
Mac users please update instructions
