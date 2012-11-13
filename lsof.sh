#!/bin/bash

LSOF=`lsof|wc -l`

if [[ $LSOF -ge 10000 ]]
then
	echo lsof | mail -s "lsof: $LSOF" di4blo@gmail.com
fi
