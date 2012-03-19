#!/bin/bash
reportfile=/var/sites/jcbconsulting.biz/web/htdocs/spam.html
> $reportfile
cd /var/qmail/qmail-scanner
for site in `ls --color=never /var/sites`
do
	echo $site
	./sa-stats-1.0.pl -r @$site -n 1 -w |grep -v Content-type | head -8 >> $reportfile
done
