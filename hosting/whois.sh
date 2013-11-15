#!/bin/bash

# Manera cutre de no mostrar symlinks
SITES=`ls -l /var/www/ | awk {'print $9'} | egrep -e ".com|.net|.org|.biz"`

for site in `echo $SITES` 
do
  /opt/scripts/domain-check-2.sh -d $site -x 30 -e xavi.carrillo@gmail.com
done

