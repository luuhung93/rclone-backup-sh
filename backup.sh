#Backup Server and Upload to Cloud

#!/bin/bash

SERVER_NAME=UNITY

TIMESTAMP=$(date +"%F")
BACKUP_DIR="/home/rclone-backup-sh/$TIMESTAMP"

SECONDS=0

mkdir -p "$BACKUP_DIR/mongo"

cd $BACKUP_DIR/mongo

echo "Starting Backup Database and";
mongodump
tar -cjf $TIMESTAMP"dump.tar.gz" dump
rm -rf dump
echo "Finished";
echo '';

size=$(du -sh $BACKUP_DIR | awk '{ print $1}')

echo "Starting Uploading Backup";
rclone move $BACKUP_DIR "remote:$SERVER_NAME/$TIMESTAMP" >> /var/log/rclone.log 2>&1
# Clean up
rm -rf $BACKUP_DIR
rclone -q --min-age 1w delete "remote:$SERVER_NAME" #Remove all backups older than 1 week
rclone -q --min-age 1w rmdirs "remote:$SERVER_NAME" #Remove all empty folders older than 1 week
rclone cleanup "remote:" #Cleanup Trash
echo "Finished";
echo '';

duration=$SECONDS
echo "Total $size, $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."