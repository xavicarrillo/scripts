#!/bin/bash
echo reinjectant missatge $1 a la cua del qmail
cat $1 |grep -v Delivered-To|/var/qmail/bin/qmail-inject

