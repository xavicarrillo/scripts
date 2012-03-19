#!/bin/bash
LOGIN=$1
MAIL=$2
DATE=`date +%b" "%e`
ACCESSOS=`grep $LOGIN /var/log/secure | grep -i "$DATE" |grep "Login successful" | awk {'print $1,$2,$3,$7'} | awk -F \[ {'print $1")"'}`
[[ "$ACCESSOS" = "" ]] && TOTAL=0 || TOTAL=`echo $ACCESSOS | tr -s "\)" "\n" | sed s/\(/"      "/g | wc -l`
echo $ACCESSOS | tr -s "\)" "\n" | sed s/\(/"      "/g | mail -s "logins $LOGIN: $DATE. Total: $TOTAL" $MAIL
