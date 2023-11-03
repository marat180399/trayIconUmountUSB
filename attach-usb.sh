#!/bin/sh
# SHELL script works at USB flash drive attachement

# Path to TRAY python script is defined here
trayPath="/home/marat/tray/tray.py"

# Chech if TRAY proccess already running:
trayPID=$(ps -ef | grep tray.py | grep -v grep | awk -v user=$domainUser '$1 == user {print $2}' | tail -n 1)

if [ $trayPID -gt 1 ]
then
	# Kill the previous TRAY process
	sudo kill -9 $trayPID
	# Run new TRAY process
	/usr/bin/sudo -u $domainUser /usr/bin/python $trayPath & exit

else
	# If TRAY process wasn't running, start new TRAY process
	/usr/bin/sudo -u $domainUser /usr/bin/python $trayPath & exit
fi