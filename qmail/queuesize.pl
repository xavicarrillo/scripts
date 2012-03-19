#!/usr/local/bin/perl

#$remote = `/opt/scripts/qmail/qmHandle -s | grep remote | cut -c 27-`;
#$local = `/opt/scripts/qmail/qmHandle -s | grep local | cut -c 26-`;

#remote l'he convertit a "messages in queue" i local a "not processed"
$remote = `/var/qmail/bin/qmail-qstat |head -1| awk {'print \$4'}`;
$local = `/var/qmail/bin/qmail-qstat |tail -1| awk {'print \$8'}`;

chomp($remote);
chomp($local);

print "Remote\:$remote Local\:$local";
