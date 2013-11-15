#!/bin/bash

EMAIL=$1
DOMINIS=`ls --color=never /var/www/vhosts/ | grep -v archives | grep -v chroot | grep -v default | grep -v migration.log`

for DOMINI in $DOMINIS
do
	cd /var/www/vhosts/$DOMINI/httpdocs
	TROBAT=`find *.php *.html *.htm -exec grep -i iframe {} 2>/dev/null \;`
	if ! [[ "$TROBAT" = "" ]]
	then
		echo $TROBAT | mail -s "Virus Iframe en domini $DOMINI!!" $EMAIL
	else
		echo "No s'han trobat virus Iframe en $DOMINI"
	fi
done
