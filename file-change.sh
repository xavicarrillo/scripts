#!/bin/bash

for x in `ls /root/named/var/ |grep -v stats|grep -v run`
do
    diff /root/named/var/$x /var/named/run-root/var/$x || echo "$x changed" | mail -s "El DNS del domini $x ha canviat a /var/named/run-root/var/ !" di4blo@gmail.com
done

