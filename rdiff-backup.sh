#!/bin/bash
 
### Variables ####
mails="di4blo@gmail.com"
directoris="/etc /opt/scripts /var/www /var/qmail /usr/local/psa" 
hostname=`hostname`
user_remot="xcarrillo"
ip_remota="91.121.179.133"
dir_remot="/var/backup/rdiff/remot/falcon"
LOCKFILE="/tmp/rdiff.lck"
ERRORFILE="/tmp/error.rdiff-backup"
MAILFILE="/tmp/mail.tmp"

### Funcions ###
function check_running_instance()
{
        test -f $LOCKFILE && (echo "another instance is running. If not, remove $LOCKFILE before running this programm" ; exit 1)
}

function data()
{
        #escriu la data/hora al mail i un texte indicant si es l'hora d'inici o de fi (segons el parametre)
        data=`date '+%e/%m/%Y - [%r]'`
        echo >> $MAILFILE
        echo "backup $1 a: " $data >> $MAILFILE
        echo >> $MAILFILE
}
 
function envia_mail()
{
        for destinatari in $mails
        do
               cat $MAILFILE | mail -s "$1" $destinatari
        done
        rm -f $MAILFILE
}
 
function ok()
{
        echo "backup de " $directori "realitzat correctament" >> $MAILFILE
}
 
function error()
{
        touch $ERRORFILE
        echo "ERROR, el backup de " $directori "no s'ha realitzat correctament" >> $MAILFILE
}
 
function comprova_si_hi_ha_errors()
{
        test -f $ERRORFILE && subject="ERROR, el backup de $hostname no s'ha realitzat correctament" || subject="backup `hostname` s'ha realitzat correctament"
}

function fes_backup()
{
        for directori in $directoris
        do
               # tamany=`du -h $directori |tail -1| awk {'print $1'}`
                rdiff-backup --print-statistics --create-full-path --force $directori $user_remot@$ip_remota::$dir_remot/$directori && ok || error
        done
}
 
### Programa principal ###
check_running_instance
touch $LOCKFILE
rm -f $ERRORFILE $MAILFILE
data iniciat
fes_backup
data finalitzat
comprova_si_hi_ha_errors
envia_mail "$subject"
rm -f $LOCKFILE

