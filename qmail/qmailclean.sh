#!/bin/bash

SUBJECTFILE="/opt/scripts/qmail/spamsubject.list"

/sbin/service qmail stop

for NAME in `cat $SUBJECTFILE`
do
	/opt/scripts/qmail/qmail-remove -i -p "$NAME" -r 
done

/sbin/service qmail start

rm -rf  /var/qmail/queue/yanked
mkdir /var/qmail/queue/yanked
