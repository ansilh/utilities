#!/bin/bash

#---------------------------------------------------------------------------#
# Move files of a scpecific date to a diffrent place                        #
#---------------------------------------------------------------------------#                                                                  # Author : Ansil H (ansilh@gmail.com)                                       #
# Date   : 03/03/2016                                                       #
# Version: 1.0                                                              #
# Log    :                                                                  #
#---------------------------------------------------------------------------#

SOURCE_DIR=${1}
DEST_DIR=${2}
if [ ! -z "${1}" -a  -d "${1}" -a ! -z ${2} -a -d ${2} ]
then
        echo -e "  Files Date\n--------------------"
        ls -lrt |grep ^- |awk '{print $9}'|xargs stat --printf="%z\n" |awk '{print $1}'|sort|uniq -c
        echo -e "--------------------"
else
        echo -e "Usage:- \n$0 <source dir> <destination dir>"
        exit
fi

read -p "Select a Date " DATE
echo ${DATE} |grep -E "[0-9][0-9][0-9][0-9]-[0-1][1-9]-[0-3][1-9]"

if [ $? -ne 0 ]
then
        echo "Invalid date format"
        exit
fi

TOTAL=`ls -lrt |grep ^- |awk '{print $9}'|xargs stat --printf="%z\n"  |awk '{print $1}'|sort|uniq -c |grep ${DATE}|awk '{print $1}'`
COUNT=1
for i in `ls ${1}`
do
        if [ -f ${SOURCE_DIR}/${i} ]
        then
                F_DATE=`stat --printf="%z\n" ${1}/${i} |awk '{print $1}'`
                if [ "${DATE}" == "${F_DATE}" ]
                then
                        echo -e "File ${COUNT} of ${TOTAL} \nMoving ${SOURCE_DIR}/${i} to ${DEST_DIR}/"
                        mv ${SOURCE_DIR}/${i} ${DEST_DIR}/
                        if [ $? -ne 0 ]
                        then
                                echo "Move Failed"
                                exit
                        fi
                        COUNT=`expr ${COUNT} + 1`
                fi
        fi
done
