#!/bin/bash
#
# chkconfig: 3 99 01

### BEGIN INIT INFO
# Required-Start: $network $local_fs
# Required-Stop: $network $local_fs
# Short-Description: Update jumpbox hostname in dns
# Description: Updates jump-<uk/us>-tunnel-up.ft.com dns address
#              to the public ip of this host, if it is different.
#              It just needs to run once when the host starts up.
### END INIT INFO

KONKEY=$(cat /root/.kon_dns_key)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | awk -F "-" '{print $1}')
NEWIP=$(curl -s 169.254.169.254/latest/meta-data/public-ipv4)


# check what region we are in and set name accordingly 
if [ ${REGION} == eu ]; then
  NAME=jump-uk-tunnel-up
elif [ ${REGION} == us ]; then
  NAME=jump-us-tunnel-up
else
  echo "Region not found."
  exit 1
fi

OLDIP=$(host ${NAME}.ft.com | awk '{print $4}')


start() {

if [ ${OLDIP} == ${NEWIP} ]; then
  echo "No udpate needed. Exiting..."
exit 0
fi

generate_post_data()
{
cat <<EOF
{
  "zone": "ft.com",
  "name": "${NAME}",
  "oldRdata": "${OLDIP}",
  "newRdata": "${NEWIP}",
  "ttl": "60"
}
EOF
}

curl -H "Content-Type: application/json" \
-H "Accept: application/json" \
-H "x-api-key: ${KONKEY}" \
-X PUT -d "$(generate_post_data)" "https://dns-api.in.ft.com/v2"

}

stop() {

  echo "This service is only here to update the DNS record on boot."
  echo "There's no need to stop or restart it."

}

status() {

  echo "This service is only here to update the DNS record on boot."
  echo "There's no need to stop or restart it."

}


# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  status)
        status
        ;;
  *)
        echo $"Usage: $0 start"
        exit 2
esac


