#!/bin/bash

echo
 
dir_backup=$1
older_than=$2

for dir in `find $dir_backup -name rdiff-backup-data | sed s/rdiff-backup-data//g`
do
    echo Removing backups on $dir olther than $older_than
    echo
    rdiff-backup --force --remove-older-than $older_than $dir
done
