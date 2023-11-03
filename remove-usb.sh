#!/bin/sh
# SHELL script works at USB flash drive detachement

# Path to TRAY python script is defined here
trayPath="/home/user/tray/tray.py"

# Chech if TRAY proccess already running:
trayPID=$(ps -ef | grep tray.py | grep -v grep | awk -v user=$domainUser '$1 == user {print $2}' | tail -n 1)

if [ $trayPID -gt 1 ]
then
	# if TRAY process is running - KILL it
	sudo kill -9 $trayPID
	
	# Check if other USB devices are mounted, run TRAY process again.
	mounted=$(mount | grep /dev/sd | awk '{print $2}' | wc -l)
	if [ $mounted -ge 1 ]
	then
		/usr/bin/sudo -u $domainUser /usr/bin/python $trayPath & exit
	fi
fi
