#!/bin/bash

SUBJECTFILE="/opt/scripts/qmail/spamsubject.list"

service qmail stop

for NAME in `cat $SUBJECTFILE`
do
	/opt/scripts/qmail/qmail-remove -i -p "$NAME" -r 
done

service qmail start

rm -rf  /var/qmail/queue/yanked
mkdir /var/qmail/queue/yanked
