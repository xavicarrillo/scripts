#!/bin/bash
CWD=/opt/scripts/qmail
#$CWD/qmHandle -l | grep From | sort -u | sort -n
#$CWD/qmHandle -l | grep To | sort | uniq -c | sort -n
$CWD/qmHandle -l | grep Subject | sort | uniq -c | sort -n
#$CWD/qmHandle -l | grep Subject | sort | uniq -c | sort -n
