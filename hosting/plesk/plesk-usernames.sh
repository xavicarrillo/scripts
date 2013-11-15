#!/usr/bin/env bash
#**********************************************
# Plesk Quick Info Script v0.0.1
# Written by Patrick Burns
#  SQL Queries provided by Christopher Haynie
#  Special Thanks to Tim G. for the help
#
#   This script simply queries mysql to give all email addresses, ftp users, and passwords
#   associated with both
#
#       Features:
#         1.  No password required
#         2.  No mysql CLI knowledge required
#         3.  OS Detection, works on both FreeBSD and Linux (only redhat right now)
#
#
#
#     last modified: 2/24/2009
#**********************************************
 
#The following function determines if the machine is FreeBSD or Linux
 
function detect_os {
        OS=$(uname)
        if [ "${OS}" == "FreeBSD" ]; then
                echo
                #freebsd stuff
        elif [ "${OS}" == "Linux" ]; then
                DIST=$(lsb_release -si)
                VER=$(lsb_release -sr)
                ARCH=$(uname -i)
        fi
}
 
#The following function is the Linux Version, scroll down for the FreeBSD function
 
function linux_run {
 
echo $OS
 
    clear
 
    echo "                                          "
    echo "                                          "
    echo "##########################################"
    echo "#                                        #"
    echo "# Quick Plesk Info Troubleshooting Script#"
    echo "#                                        #"
    echo "#    Below are the email addresses       #"
    echo "#            on this server              #"
    echo "#                                        #"
    echo "##########################################"
    echo "                                          "
    echo "                                          "
 
mysql -u admin -p`cat /etc/psa/.psa.shadow` psa -e "SELECT accounts.id, mail.mail_name, accounts.password, domains.name FROM domains LEFT JOIN mail ON domains.id = mail.dom_id LEFT JOIN accounts ON mail.account_id = accounts.id"
 
    echo "                                          "
    echo "                                          "
    echo "##########################################"
    echo "#                                        #"
    echo "#      Below are the ftp users           #"
    echo "#           on this server               #"
    echo "#                                        #"
    echo "##########################################"
    echo "                                          "
    echo "                                          "
 
mysql -u admin -p`cat /etc/psa/.psa.shadow` psa -e "select s.login,s.home,a.password from sys_users s,accounts a where a.id=s.account_id"
cat /opt/scripts/llistaUsuaris.ftp |sort -u
}  #END linux portion
#Main Program:
 
detect_os
 
if [ "$OS" = "Linux" ]; then
	linux_run
else
	freebsd_run
fi
