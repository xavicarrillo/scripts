#!/bin/bash

usage () {
        echo "Usage: $0 -u username -p password -h homedir -d domain"
	echo "Ex: ./crea_ftp.sh -u miguelangel -p sidiifni -h /caca -d zedis.com"
	echo "El home sera /var/www/vhosts/zedis.com/httpdocs/extranet/caca"
	echo "nomes va be per zedis.com!"
        exit 1
}

# Break if there's no arguments
[[ "$#" -eq "0" ]] && usage

# Don't loop more than the number of arguments - see below why this exists
MAX_ARG_LOOPS="$#"

# Get arguments
while (( $# ))
do
        case $1 in

                -u)
                        USERNAME=$2
                        shift 2
                        ;;
                -p)
                        PASSWORD=$2
                        shift 2
                        ;;
                -d)
                        DOMAIN=$2
                        shift 2
                        ;;
                -h)
                        HOMEDIR=$2
                        shift 2
                        ;;
                *)
                        usage
        esac

        # This prevents the while cycle from entering an infinite loop if we don't specify a value for the last argument
        ARG_LOOPS=$((ARG_LOOPS + 1))
        [[ "$ARG_LOOPS" -gt "$MAX_ARG_LOOPS" ]] && break
done

BASEDIR="/var/www/vhosts/$DOMAIN/httpdocs/extranet"
DOMAIN_UID=`grep $DOMAIN /etc/passwd | head -1 | awk -F: {'print $3'}`
USUARI_EXISTEIX=`grep "$USERNAME" /etc/passwd`

if [[ "$USUARI_EXISTEIX" = "" ]]; then
	DIR="$BASEDIR/$HOMEDIR"
	if ! [ -d "$DIR" ]
	then
		mkdir $DIR || ( echo "no es pot crear el directori"; exit 1 )
	fi

	chown zedis:psaserv $DIR || ( echo "no es poden canviar els permisos del directori"; exit 1 )
	/usr/sbin/useradd -u $DOMAIN_UID -o -d $DIR -g psacln -p $PASSWORD -s /bin/false $USERNAME  || ( echo "no es pot afegir l'usuari de sistema"; exit 1 )
	/opt/scripts/chpasswd $USERNAME $PASSWORD || ( echo "no es pot canviar el password"; exit 1 )
	/usr/bin/mysql -u admin -pathi3LaL9 panelftp -e "INSERT INTO ftp(username,passwd,home) VALUES ('$USERNAME','$PASSWORD','$HOMEDIR')"
	echo "Usuari creat correctament"
	exit 0
else
	echo "Usuari $USERNAME existeix"
	exit 1
fi
