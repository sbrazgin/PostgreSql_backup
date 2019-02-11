#!/bin/bash

########################################################################
# Sergey Brazgin     01.2019    IAC DZM
# mail:   sbrazgin@gmail.com
########################################################################
GEN_ERR=1  # something went wrong in the script

#-----------------------------------------------------------------------
# get date time string
function sbstat_get_dir_nameD {
  CURR_DATE=`date '+%Y-%m-%d_%H:%M'`
  echo "${CURR_DATE}"
}

#-----------------------------------------------------------------------
# get date time dir
# params: 1-dir
function sbstat_get_dir_nameD2 {
  CURR_DATE=$(sbstat_get_dir_nameD) 
  if [ $# -eq 0 ]
  then
    echo "${CURR_DATE}"
  elif [ $# -eq 1 ]
    then
    echo "$1/${CURR_DATE}" 
  else
    echo "$1/$2/${CURR_DATE}" 
  fi
}

#-----------------------------------------------------------------------
# add string to status file
# params: 1-date 2-type
function sbstat_set_statusStart {
  echo "$1 $2 Start" | tee -a status.log
}

#-----------------------------------------------------------------------
# add string to status file
# params: 1-date 2-type
function sbstat_set_statusOK {
  echo "$1 $2 OK" | tee -a status.log
}

#-----------------------------------------------------------------------
# create file with spec date oldet then n days
#params: 1-type 
#        2-count days
function sbstat_set_file_to_del {
  if [ $# -ne 2 ]
  then
    echo "params not set!"
    exit ${GEN_ERR}  
  fi
  LASTSTR=`tac status.log |grep -m 1 "$1 OK"`
  echo "LASTSTR=<${LASTSTR}>"
  if [ -z ${LASTSTR} ]; then 
    echo "$1 OK not found!"
    exit ${GEN_ERR}
  fi
  
  LASTDATE=`echo "${LASTSTR}" | cut -d '_' -f1`
  echo "LASTDATE=<$LASTDATE>"
  if [ -z ${LASTDATE} ]; then 
    echo "LASTDATE is empty !"
    exit ${GEN_ERR}
  fi
  
  touch -d "${LASTDATE} -$2 days" +'%Y-%m-%d' last_date_file.log
  code=$?

  if [ $code -ne 0 ]; then
    echo "touch error, code: $code"
    exit ${GEN_ERR}
  fi
  ls -la last_date_file.log
}


#-----------------------------------------------------------------------
# check last backup created
# params: 1-type 
function sbstat_check_today_backup_status {

  currenttime=$(date +%H:%M)
  echo "$currenttime"

  if [[ "$currenttime" > "20:00" ]] && [[ "$currenttime" < "23:59" ]] 
  then
	CURR_DATE=`date '+%Y-%m-%d_2'`
	echo "type 1. check :${CURR_DATE}"

	if grep -q "^${CURR_DATE}.* $1 OK$" status.log
	then
	  echo "OK - current"
	  exit 0
	fi  
  else
	CURR_DATE=`date '+%Y-%m-%d'`
	echo "type 2.1. check :${CURR_DATE}"

	if grep -q "^${CURR_DATE}.*$1 OK$" status.log
	then
	  echo "OK - current"
	  exit 0
	fi  
	
    CURR_DATE=`date '+%Y-%m-%d_2' --date="yesterday"`
	echo "type 2.2. check :${CURR_DATE}"
	if grep -q "^${CURR_DATE}.*$1 OK$" status.log
	then
	  echo "OK - current"
	  exit 0
	fi  
  fi

  echo "not found success backup"
  exit 1

}