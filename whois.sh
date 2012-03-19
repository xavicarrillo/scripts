#!/bin/bash

#/opt/scripts/domain-check-2.sh -a -f /opt/scripts/sites.txt -q -x 20 -e di4blo@gmail.com

SITES=`ls /var/www/vhosts/ | egrep -e ".com|.net|.org|.biz"`

for site in `echo $SITES ; echo laseu.net` 
do
	/opt/scripts/domain-check-2.sh -d $site -x 30 -e xavi.carrillo@gmail.com
done

