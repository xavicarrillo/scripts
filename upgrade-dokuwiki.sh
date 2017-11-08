#!/bin/bash

DOMAIN="hastaelfindelmundo.net"
ZIPFILE='dokuwiki-stable.tgz'
USERS_AUTH='dokuwiki/conf/users.auth.php'

cd /var/www/vhosts/$DOMAIN
wget https://download.dokuwiki.org/src/dokuwiki/$ZIPFILE
tar xzvf $ZIPFILE
rm -f $ZIPFILE

mv dokuwiki/data .
mv $USERS_AUTH .
rm -rf dokuwiki
mv dokuwiki-2* dokuwiki
rm -rf dokuwiki/data $USERS_AUTH
mv data dokuwiki/
mv users.auth.php $USERS_AUTH
chmod o-g $USERS_AUTH
chown apache:apache dokuwiki -R
