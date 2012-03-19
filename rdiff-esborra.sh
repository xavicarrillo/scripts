#!/bin/bash
#esborra els backups mes antics de 2 setmanes

echo
 
dir_backup="/var/backup/rdiff/remot/laseu/"
for dir in `find $dir_backup -name rdiff-backup-data | sed s/rdiff-backup-data//g`
do
	echo $dir
        rdiff-backup --force --remove-older-than 2W $dir
	echo
done
