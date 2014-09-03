#!/bin/bash

HOSTNAME="hostname or IP address"
MOUNT_PATH="/home/user/whatever/"

echo 'DISCONNECTING SSHFS '$HOSTNAME'...'
fusermount -u $MOUNT_PATH
echo 'DISCONNECTED...'
