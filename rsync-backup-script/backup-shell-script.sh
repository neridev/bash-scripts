#!/bin/bash
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# READ ME FIRST!!!
#
# Backup variables description:
# UUID -> Setting your own UUID of HDD use for backup
# DRIVE -> grep mount path from /proc/mounts
# BACKUPDIR -> path where copy backup
# TOBACKUP -> files for backup
# TIME -> time for log file
# LOG -> path to log file for logging
# 
# Use "blkid" for know UUID you HDD
# Cat /proc/mounts for mount path of your HDD
# You have to a create log file and setting right permissions!
# Customize XXXXX parts...
#

#backup variables
TIMER=4
UUID='XXXXX' #example 6edf5-7b-a5-1e-4b54
DRIVE='XXXXX' #example /dev/mapper/truecrypt3\s/media/truecrypt3\sext4
BACKUPDIR='XXXX' #example /media/truecrypt3/backup/
TOBACKUP='XXXXX' #example /home/
TIME=$(date +"%b %d %Y %T")
LOG='/var/log/backup.log'

###############################################################

echo $TIME 'Start backup script to external HDD' >> $LOG
echo $TIME 'HDD UUID:' $UUID >> $LOG

#check if drive match
if /sbin/blkid | grep -q "$UUID"; then
        echo $TIME 'External HDD match... [OK]' >> $LOG
else
        echo $TIME 'External HDD not match... [FAILED]' >> $LOG
        echo $TIME 'EXIT!' >> $LOG
        echo $TIME '###########################################' >> $LOG
        exit
fi

#check if drive mounted
if grep -qs $DRIVE /proc/mounts; then
        #HDD already mounted
        echo $TIME 'External HDD already mounted... [OK]' >> $LOG
        #KNOW MOUNT POINT and WRITE TO LOG
        MOUNT=`grep XXXXX /proc/mounts | awk '{ print $2 }'` #example /dev/mapper/truecrypt3
        echo $TIME 'Mounted: '$MOUNT >> $LOG

else
        #HDD not mouted
        echo $TIME 'External HDD not mounted... [FAILED]' >> $LOG
        echo $TIME 'EXIT!' >> $LOG
        echo $TIME '###########################################' >> $LOG
        exit
fi

#check if backup dir exist
if [ -d $BACKUPDIR ]; then
        #backup dir exist
        echo $TIME 'Backup directory '$BACKUPDIR' exist... [OK]' >> $LOG
else
        #backup dir not exist
        echo $TIME 'Backup directory '$BACKUPDIR' exist... [FAILED]' >> $LOG
        echo $TIME 'EXIT!'
        echo $TIME '###########################################' >> $LOG
        exit
fi

#start backup
echo $TIME 'Starting backup...' >> $LOG
# CUSTOMIZE THIS PART FOR YOUR NEEDS
echo $TIME "rsync -rave --verbose --stats --delete --include '.icedove' --include '.VirtualBox' --include '.screenlayout' --exclude '.*' --exclude 'xNFS' --exclude 'Media' $TOBACKUP $BACKUPDIR" >> $LOG
rsync -rave --verbose --stats --delete --include '.icedove' --include '.VirtualBox' --include '.screenlayout' --exclude '.*' --exclude 'xNFS' --exclude 'Media' $TOBACKUP $BACKUPDIR >> $LOG

# USE FOR MANUAL RUN FROM SHELL...
#
#countdown before backup
#printf "\nStarting Backup... "
#until [ $TIMER = 0 ]; do
#       printf "$TIMER... "
#        TIMER=`expr $TIMER - 1`
#        sleep 1
#done
#printf '\n'

echo $TIME 'BACKUP COMPLETE... [OK]' >> $LOG
echo $TIME '###########################################' >> $LOG
