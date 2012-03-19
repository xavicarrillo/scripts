#!/bin/bash
 
### Variables ####
sqlbackupdir="/var/backup/rdiff/local/mysql"
directoris="$sqlbackupdir
	    /usr/local/psa/
	    /opt/scripts
	    /var/qmail/
	    /etc
            /var/www"
mails="di4blo@gmail.com"
hostname=`hostname`
user_remot="xcarrillo"
ip_remota="91.121.179.133"
dir_remot="/var/backup/rdiff/remot/falcon"
tmp_mail_file="/tmp/mail.tmp"
sqluser="admin"
sqlpasswd="`cat /etc/psa/.psa.shadow`"
mysqldump="mysqldump -u$sqluser -p$sqlpasswd -a --opt -A --allow-keywords"
bzip2=`which bzip2`
DATE=`date +%Y-%m-%d`

 
### Funcions ###
function data()
{
        #escriu la data/hora al mail i un texte indicant si es l'hora d'inici o de fi (segons el parametre)
        data=`date '+%e/%m/%Y - [%r]'`
        echo >> $tmp_mail_file
        echo "backup $1 a: " $data >> $tmp_mail_file
        echo >> $tmp_mail_file
}
 
function envia_mail()
{
        for destinatari in $mails
        do
               cat $tmp_mail_file | mail -s "$1" $destinatari
        done
        rm $tmp_mail_file
}
 
function ok()
{
        error=0
        echo "backup de " $directori "realitzat correctament" >> $tmp_mail_file
}
 
function error()
{
        error=1
        echo "ERROR, el backup de " $directori "no s'ha realitzat correctament" >> $tmp_mail_file
}
 
function mysql-dump()
{
        $mysqldump | $bzip2 -c > $sqlbackupdir/$hostname-$DATE.sql.bz2 && ok || error

}
 
function comprova_si_hi_ha_errors()
{
        if [ $error -eq 1 ]
        then
                subject="ERROR, el backup de $hostname no s'ha realitzat correctament"
        else
                subject="backup `hostname` s'ha realitzat correctament"
        fi
}
 
function fes_backup()
{
        for directori in $directoris
        do
               # tamany=`du -h $directori |tail -1| awk {'print $1'}`
                rdiff-backup --force $directori $user_remot@$ip_remota::$dir_remot/$directori && ok || error
        done
}
 
### Programa principal ###
data iniciat
mysql-dump
fes_backup
data finalitzat
comprova_si_hi_ha_errors
envia_mail "$subject"

