#!/bin/bash
if test -z "$1"
then
	echo "has de pasar una cuenta como parametro. P.e: ./borra_Maildir.sh xavi@exemple.com"
	exit 1
else
	user=`echo $1|awk -F@ {'print $1'}`
	dominio=`echo $1|awk -F@ {'print $2'}`
	directorio=/var/sites/$dominio/mail/$user/Maildir/new

	rm -rf $directorio 
	mkdir $directorio 
	chmod 700 $directorio 
	chown popuser:popuser $directorio 

	directorio=/var/sites/$dominio/mail/$user/Maildir/cur
	rm -rf $directorio
	mkdir $directorio
	chmod 700 $directorio
	chown popuser:popuser $directorio
fi
