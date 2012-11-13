#!/bin/bash

#/opt/scripts/domain-check-2.sh -a -f /opt/scripts/sites.txt -q -x 20 -e di4blo@gmail.com

# Manera cutre de no mostrar symlinks
SITES=`ls -l | grep -v "\->" |grep -v chroot|grep -v kroak.net |grep -v default |awk {'print $9'} | egrep -e ".com|.net|.org|.biz"`

for site in `echo $SITES` 
do
	/opt/scripts/domain-check-2.sh -d $site -x 30 -e xavi.carrillo@gmail.com
done

