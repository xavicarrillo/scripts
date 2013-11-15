#!/bin/bash
mail=$1
directori_quarentena="/var/qmail/qmail-scanner/quarantine/new"
if test -z $1
then
        echo "No has passat l'adreça de correu de qui vols reinjectar tots els mails"
	echo "nota: es igual que reinjectem tots els mails."
	echo "Els que son spam els tornara a filtrar, i els legitims passaran (si em fet els deguts canvis al local.cf)"
	exit 1
else

for x in `grep -r $mail $directori_quarentena | awk -F/ {'print $8'} | awk -F: {'print $1'} | sort | uniq`
do
	echo reinjectant missatge $x a la cua del qmail
	cat $directori_quarentena/$x |grep -v Delivered-To|/var/qmail/bin/qmail-inject
done
fi
