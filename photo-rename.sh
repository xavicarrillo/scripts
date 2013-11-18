#!/bin/bash
# Put the pictures on directories and they will be named after the directory.
# The idea is to create folders and subfolders with the names of the cities/places so that the photos will take those names
#
# For instance:
#
#
# ./Japan/NSD_001.JPG   
# ./Japan/Tokyo/NSD_007i.JPG
# ./Japan/Tokyo-Shibuya/NSD_0355.JPG
#
# Put photo-rename into ./Japan and just run it, and the pictures  will be ranamed to
# Japan_001.JPG
# Tokyo_007.JPG
# Tokyo_Shibuya_0355.JPG
#
# Make a backup first, just in case! ;)
#

ORIGINAL_DIR=`pwd`
for DIR in `find ${ORIGINAL_DIR} -type d`
do
  cd "${DIR}"
  CURRENT_DIR=`echo ${PWD##*/}`
  for FILE in `find . -maxdepth 1 -type f|grep -v photo-rename.sh`
  do
    NUMBER=`echo ${FILE}| awk -F_ {'print $2'}`
    EXTENSION=`echo ${FILE}| awk -F\. {'print $3'}`
    NEWNAME="${CURRENT_DIR}_${NUMBER}.${EXTENSION}"
    echo filename is $FILE and new name will be $NEWNAME
    mv $FILE $NEWNAME
  done
done
