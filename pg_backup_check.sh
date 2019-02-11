#!/bin/bash
########################################################################
# Sergey Brazgin     12.2018    IAC DZM
# e-mail:   sbrazgin@gmail.com
########################################################################
# 2019-01-07_21:00 OK

BACKUP_TYPE="DUMP_BACKUP"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# check current day

currenttime=$(date +%H:%M)
echo "$currenttime"

if [[ "$currenttime" > "20:00" ]] && [[ "$currenttime" < "23:59" ]] 
then
	CURR_DATE=`date '+%Y-%m-%d_2'`
	echo "type 1. check :${CURR_DATE}"

	if grep -q "^${CURR_DATE}.*${BACKUP_TYPE} OK$" status.log
	then
	  echo "OK - current"
	  exit 0
	fi  
else
	CURR_DATE=`date '+%Y-%m-%d'`
	echo "type 2.1. check :${CURR_DATE}"

	if grep -q "^${CURR_DATE}.*${BACKUP_TYPE} OK$" status.log
	then
	  echo "OK - current"
	  exit 0
	fi  
	
    CURR_DATE=`date '+%Y-%m-%d_2' --date="yesterday"`
	echo "type 2.2. check :${CURR_DATE}"
	if grep -q "^${CURR_DATE}.*${BACKUP_TYPE} OK$" status.log
	then
	  echo "OK - current"
	  exit 0
	fi  
fi


echo "not found success backup"
exit 1
