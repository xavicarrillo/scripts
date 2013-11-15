#!/bin/bash
#
# Includes a lot bashisms
# 

LOGDIR=~/builder/
MACH_CHROOTS=/var/lib/mach/chroot
error_message() {
	cat <<EOF
You must run the command metamach with the action and an optional parameter,
which my be required by the action

	build file.spec
	status file.spec
EOF
	exit 1
}

[ -z $1 ] && error_message

# When calling it you must pass the name of the variable
# and a spec filename and it will assign the name of the
# package in the variable passed.
#
# package_name PKG_NAME ~/.rpm/SPEC/net-snmpd.spec
package_name() {
	PACKAGE_NAME=$(cat $2 | awk '/^Name:/ { print $2 }' )
	eval $1=$PACKAGE_NAME
}

# Change the status of a BUILD_ID passed as a parameter.
# As first paramenter it receives the BUILD_ID
# The second parameter must be the STATUS: S, F, E or R
# The third parameter is optional and it's the chroot.
change_status() {
	# TODO ¿Esas variables están disponibles?
	STATUS_DIR=$LOGDIR/$RPM_NAME
	NEW_FILENAME=$1.$3,$2
	mv $STATUS_DIR/$1.*,[SFER]
}

display_status() {
	STATUS_DIR=$LOGDIR/$RPM_NAME
	FILENAME=$(ls $STATUS_DIR/$1.*,[SFER])
	OWNER=$(stat --printf '%U' $FILENAME)
	FILEDATE=$(stat --printf '%y' $FILENAME)
	CHROOT=$(echo $FILENAME | sed 's/.*\.\(.*\),./\1/')
	STATUS=${FILENAME: -1:1}
	case $STATUS in
		S) STATUS_TEXT="Started running (launched by $OWNER)"
		   ;;
		F) STATUS_TEXT="Finished at $FILEDATE (launched by $OWNER)"
		   ;;
		E) STATUS_TEXT="Error building $CHROOT at $FILEDATE (launched by $OWNER)"
		   ;;
		R) STATUS_TEXT="Building for $CHROOT since $FILEDATE (launched by $OWNER)"
		   ;;
		*) STATUS_TEXT="Unknown. Last action at $FILEDATE, launched by $OWNER"
                   ;;
	esac
}

# Launchs a build. Spec filename must be passed as the
# first parameter and chroot as the second one.
build() {
	mach -r $2 $1
}	

launch_builds() {
	package_name RPM_NAME $1
	mkdir -p $LOGDIR/$RPM_NAME
	BUILD_ID=$(basename $(mktemp -p $LOGDIR build-XXXX.,S))
	for ROOT in $MACH_CHROOTS ; do
		change_status "$BUILD_ID" "S" "$ROOT" 
	done
	change_status "$BUILD_ID" "F"
}



case $1 in
	build) [ -z $2 ] && error_message
	       launch_builds $2
	       ;;
	*) error_message
esac
