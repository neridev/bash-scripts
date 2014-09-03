#!/bin/bash

HOSTNAME="hostname or IP address"
USER="user"
MOUNT_PATH="/home/user/whatever"
PORT="2222"

echo 'CHECKING PORT '$PORT' on '$HOSTNAME'...'
nc -z -w5 $HOSTNAME $PORT
if [ $? -eq 0 ] ; then
	echo 'CONNECTING SSHFS '$HOSTNAME'...'
	sshfs $USER@$HOSTNAME:/ $MOUNT_PATH -p $PORT
	echo 'CONNECTED...'
	else
	echo 'CAN NOT CONECT SSHFS, SSH on '$HOSTNAME' DOES NOT RUNNING...!'
fi
