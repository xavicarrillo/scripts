#!/bin/bash
MAIL="di4blo@gmail.com"
HOST=$1
DATE=`date +%b" "%e`
LOG="/usr/local/psa/var/log/maillog"
SUCCESS_TMPFILE="/tmp/success-laseu-temp"
FAILED_TMPFILE="/tmp/failed-laseu-temp"
MAIL_TMPFILE="/tmp/mail-temp"

# We redirect the output to a file because if we store it on a variable it puts everything on a file, thus can't count the number of lines
grep "IMAP connect from" $LOG | grep -v FAILED | grep -v prova | grep -v admin | awk {'print $12'} | sed s/user=//g | sed s/,//g | sort -u > $SUCCESS_TMPFILE
grep "LOGIN FAILED" $LOG | sort -u > $FAILED_TMPFILE

SUCCESS_TOTAL=`/bin/cat $SUCCESS_TMPFILE | wc -l`
FAILED_TOTAL=`/bin/cat $FAILED_TMPFILE | wc -l`

/bin/echo "Successfull logins" > $MAIL_TMPFILE
/bin/cat $SUCCESS_TMPFILE >> $MAIL_TMPFILE
/bin/echo "Failed logins" >> $MAIL_TMPFILE
/bin/cat $FAILED_TMPFILE >> $MAIL_TMPFILE

/bin/cat $MAIL_TMPFILE | mail -s "Logins $HOST: $DATE. Total SUCCESS: $SUCCESS_TOTAL. Total FAILED: $FAILED_TOTAL" $MAIL

rm -f $SUCCESS_TMPFILE $FAILED_TMPFILE $MAIL_TMPFILE
