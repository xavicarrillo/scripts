#!/bin/bash

SQLPASSWORD=`grep PASS_MYSQL /opt/scripts/includes/Parametros.inc |awk -F\" {'print $4'}`

for x in `mysql -uroot -p$SQLPASSWORD inlander -e "select username from alias"|grep -v \|`
do
	/opt/scripts/qmail/reinjecta-mail.sh $x
done
