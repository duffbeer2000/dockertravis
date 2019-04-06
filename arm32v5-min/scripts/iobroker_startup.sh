#!/bin/bash

#Reading ENV-Variables
avahi=$AVAHI
ADMIN_PORT=$IOBROKER_ADMIN_PORT
WEB_PORT=$IOBROKER_WEB_PORT

#Deklarate variables
HOSTNAME_NEW=$(hostname)

# Getting date and time for logging 
dati=`date '+%Y-%m-%d %H:%M:%S'`

# Information
echo ''
echo '----------------------------------------'
echo '-----   Image-Version: 0.2.0 beta  -----'
echo '-----      '$dati'      -----'
echo '----------------------------------------'
echo ''
echo 'Startupscript running...'

# Restoring if ioBroker-folder empty
cd /opt/iobroker
if [ `ls -1a|wc -l` -lt 3 ];
then
	echo ''
	echo 'Directory /opt/iobroker is empty!'
	echo 'Restoring...'
	cd /opt/iobroker
	tar -xf /opt/initial_iobroker.tar -C /
	echo 'Restoring done...'
fi

if [ -f /opt/scripts/.install_host ];
then
	HOSTNAME_OLD=$(cat /opt/scripts/.install_host)
	echo ''
	echo 'First run preparation! Used Hostname:' $(hostname)
	echo 'Renaming ioBroker...'
	iobroker host $(cat /opt/scripts/.install_host)
	rm -f /opt/scripts/.install_host
	echo 'ioBroker renamed...'
	echo 'First run preparation done...'
fi

# Checking for and setting up avahi-daemon
if [ "$avahi" = "true" ]
then
	echo ''
	echo 'Initializing Avahi-Daemon...'
	sudo bash /opt/scripts/avahi_startup.sh
	echo 'Initializing Avahi-Daemon done...'
fi

sleep 5

if [[ ${ADMIN_PORT} != *"8081"* ]]; then
	cd /opt/iobroker
	iobroker set admin.0 --port ${ADMIN_PORT}
fi

if [[ ${WEB_PORT} != *"8082"* ]]; then
	cd /opt/iobroker
	iobroker set web.0 --port ${WEB_PORT}
fi


# Starting ioBroker
echo ''
echo 'Starting ioBroker...'
cd /opt/iobroker
sudo -H -u iobroker node node_modules/iobroker.js-controller/controller.js >/opt/scripts/docker_iobroker.log 2>&1 & >/opt/scripts/docker_iobroker.log 2>&1 &
echo 'ioBroker started...'

# Preventing container restart
tail -f /dev/null