#!/bin/sh

SQLUSER="admin"
SQLPASSWD="`cat /etc/psa/.psa.shadow`"
MYSQLDUMP="mysqldump -u$SQLUSER -p$SQLPASSWD -a -A --opt --allow-keywords"
BZIP2=`which bzip2`
BACKUPDIR="/var/backup/mysql"
SERVER="falcon.jcbconsulting.biz"
DATE=`date +%Y-%m-%d`

echo "Dumping ALL databases to $BACKUPDIR":
$MYSQLDUMP | $BZIP2 -c > $BACKUPDIR/$SERVER-$DATE.sql.bz2 && echo done || echo something went wrong!

echo "Deleting SQL dumps older than 7 days:"
find $BACKUPDIR -type f -mtime +7 -exec rm -f {} \;  && echo done || echo something went wrong!

