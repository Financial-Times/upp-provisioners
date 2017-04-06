#!/bin/bash

# Author:
#  Jussi Heinonen <jussi.heinonen@ft.com>
#
# License: Apache License, Version 2.0, http://www.apache.org/licenses/LICENSE-2.0

# chkconfig: - 99 00
# description: Wrapper script for Neo4j
# processname: neo4j
#
### BEGIN INIT INFO
# Provides:		neo4j
# Required-Start:	$network
# Should-Start:		$syslog
# Required-Stop:	$network
# Default-Start:
# Default-Stop:
# Short-Description:	Starts and stops Neo4j processes.
# Description:		Starts and stops Neo4j processes
### END INIT INFO

SCRIPT="<%= scope['neo4jha::neo4j_home'] -%>/bin/neo4j"
USER="<%= scope['neo4jha::username'] -%>"

case "$1" in
start)
	su - ${USER} -c "${SCRIPT} start"
	rtrn=$?
	if [[ $? -eq 0 ]]; then
		touch /var/lock/subsys/neo4j
	else
		rm -f /var/lock/subsys/neo4j
	fi
;;
restart|reload|force-reload|condrestart|try-restart)
	su - ${USER} -c "${SCRIPT} restart"
	rtrn=$?
;;
status)
	su - ${USER} -c "${SCRIPT} status"
	rtrn=$?
;;
stop)
	su - ${USER} -c "${SCRIPT} stop"
	rtrn=$?
	if [[ $? -eq 0 ]]; then
		rm -f /var/lock/subsys/neo4j
	else
		rm -f /var/lock/subsys/neo4j
	fi
;;
*)
	echo "usage: $0 {start|stop|restart|reload|force-reload|condrestart|try-restart|status}"
	rtrn=2
;;
esac

exit $rtrn
