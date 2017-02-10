#!/bin/bash
# Carefull, this is personalised jast for hastaelfindelmundo.net since we only have WP and dokuwiki
# It removes everything and does a clean install

DATE=`date +%Y-%m-%d`
DOMAIN="hastaelfindelmundo.net"

# We download it first to have minimum downtime
cd /var/www/vhosts/
wget https://wordpress.org/latest.zip
unzip latest.zip

read -p "Press [Enter] key to start the backup..."
/usr/local/bin/backup_sql.sh /root/Dropbox/backups/sql
tar cjvf /root/Dropbox/backups/$DOMAIN-${DATE}.tar.bz2 $DOMAIN

read -p "Press [Enter] key to start the upgrade..."
mv $DOMAIN/.htaccess ~ 
mv $DOMAIN/dokuwiki ~ 
mv $DOMAIN/wp-config.php ~ 
mv $DOMAIN/wp-content ~ 
rm -rf $DOMAIN/*
rm -rf wordpress/wp-content wordpress/wp-config*
mv wordpress/* $DOMAIN
mv ~/wp-config.php $DOMAIN
mv ~/wp-content $DOMAIN
mv ~/.htaccess $DOMAIN
chown apache:apache $DOMAIN -R
mv ~/dokuwiki $DOMAIN
rmdir wordpress
rm -f latest.zip

echo 'SUCCESS, WordPress has been updated'
