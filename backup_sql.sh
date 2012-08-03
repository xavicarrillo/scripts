#!/bin/sh

SQLUSER="admin"
SQLPASSWD="`cat /etc/psa/.psa.shadow`"
MYSQLDUMP="mysqldump -u$SQLUSER -p$SQLPASSWD -a -A --opt --allow-keywords"
BZIP2=`which bzip2`
BACKUPDIR="/var/backup/rdiff/local/mysql"
SERVER="falcon.jcbconsulting.biz"
DATE=`date +%Y-%m-%d`

$MYSQLDUMP | $BZIP2 -c > $BACKUPDIR/$SERVER-$DATE.sql.bz2

