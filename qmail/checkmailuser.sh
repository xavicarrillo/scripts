# angegeben wurde!
#
# Zur Zeit wird nur der recipient geprüft!
#
# RETURN CODES
# 111 = temp error
# 2   = misuse
# 1   = unknown user
# 0   = alles okay, die mailaddy existiert
PATH="/command:/bin:/usr/bin:/usr/local/bin"
SQLUSER="inlander"
SQLPASS="qzhKzRkkMgAys"
RECIPIENT="ajuntamentstarragona@portalmusica.com"

# exit 0

test -z $RECIPIENT && exit 2
test -z $SENDER    && exit 2

# falls logging erwünscht:
#exec 1>&2
#echo "mysql check: pid $$ $SENDER -> $RECIPIENT"

USER=`echo $RECIPIENT| cut -d@ -f1`
HOST=`echo $RECIPIENT| cut -d@ -f2`

test -z $USER && exit 111
test -z $HOST && exit 111

OK=`mysql \
 --password="$SQLPASS" \
 --user="$SQLUSER" \
 --exec="
USE confixx;
SELECT prefix,domain
FROM email
WHERE (prefix='$USER' AND domain='$HOST') OR (prefix='*' AND domain='$HOST');"`

# wenn leer, dann user nicht okay!
test "x" == "x$OK" && exit 1

# sonst okay :)
#echo "$OK"
exit 0
