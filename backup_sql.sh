#!/bin/bash

SQLUSER="admin"
SQLPASSWD="`cat /etc/psa/.psa.shadow`"
MYSQLDUMP="mysqldump -u$SQLUSER -p$SQLPASSWD -a --opt --allow-keywords"
BZIP2=`which bzip2`
BACKUPDIR="/var/backup/mysql"
SERVER="falcon.jcbconsulting.biz"
DATE=`date +%Y-%m-%d`

for DATABASE in `mysql -u$SQLUSER -p$SQLPASSWD -s -N -e 'show databases'`
do
  echo "Dumping $DATABASE onto $BACKUPDIR":
  $MYSQLDUMP $DATABASE | $BZIP2 -c > $BACKUPDIR/$DATABASE-$DATE.sql.bz2 && echo done || echo something went wrong!
done

echo "Deleting SQL dumps older than 14 days:"
find $BACKUPDIR -type f -mtime +14 -exec rm -f {} \;  && echo done || echo something went wrong!

