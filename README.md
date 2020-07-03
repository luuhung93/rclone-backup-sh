# backup-sh

#install

https://rclone.org/install/
curl https://rclone.org/install.sh | sudo bash

#config

#https://rclone.org/drive/
rclone config

//auto 2:00AM everything day.

EDITOR=nano crontab -e

0 2 * * * /home/rclone-backup-sh/backup.sh > /dev/null 2>&1


// At 00:00 on Sunday
0 0 * * 0 
