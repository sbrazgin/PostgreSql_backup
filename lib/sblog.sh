#!/bin/bash
GEN_ERR=1  # something went wrong in the script

########################################################################
# Sergey Brazgin     12.2018    IAC DZM
# mail:   sbrazgin@gmail.com
########################################################################
# before set log name in LOG_FILE_NAME env
#LOG_NAME="log/update_${ORACLE_SID}.log"

LOG_NAME="${LOG_FILE_NAME}"


# log reset
function reset_log {
  echo " " > ${LOG_NAME}
}

# name_log - file name
function print_log {
  current_date=`date +%d.%m.%Y\ %H:%M:%S`
  if [ $# -eq 0 ]
  then
    echo "${current_date} " | tee -a ${LOG_NAME}
  elif [ $# -eq 1 ]
    then
    echo "${current_date}  $1" | tee -a ${LOG_NAME}
  elif [ $# -eq 2 ]
    then
    echo "${current_date}  $1  $2" | tee -a ${LOG_NAME}
  elif [ $# -eq 3 ]
    then
    echo "${current_date}  $1  $2  $3" | tee -a ${LOG_NAME}
  else
    echo "${current_date}  $1  $2  $3  $4 " | tee -a ${LOG_NAME}
  fi
}

# checkName status 
# name_log - file name
function print_mail_log {
  current_date=`date +%d.%m.%Y\ %H:%M:%S`
  if [ $# -eq 0 ]
  then
    echo "${current_date} " | tee -a ${LOG_NAME}
  elif [ $# -eq 1 ]
    then
    echo "${current_date}  $1" | tee -a ${LOG_NAME}
  elif [ $# -eq 2 ]
    then
    echo "${current_date}  $1  $2"  | tee -a ${LOG_NAME}
    echo "${current_date} ${ORACLE_SID} $1 $2 " | mailx -s "${current_date} ${ORACLE_SID} $1 $2 " -r srv-cad-dvh@mosmedzdrav.ru  sbrazgin@gmail.com
  else
    echo "${current_date}  $1  $2  $3 " | tee -a ${LOG_NAME}
  fi
}


function mail_send_log {
  current_date=`date +%d.%m.%Y\ %H:%M:%S`
  ###echo "${current_date} ${ORACLE_SID} Current log " | mailx -s "${current_date} ${ORACLE_SID} Current log " -r srv-cad-dvh@mosmedzdrav.ru  -a ${LOG_NAME}  sbrazgin@gmail.com
  ###mailx -s "${current_date} ${ORACLE_SID} Current log " -r srv-cad-dvh@mosmedzdrav.ru sbrazgin@gmail.com < ${LOG_NAME}
  mailx -s "${current_date} ${ORACLE_SID} Current log " -r sbrazgin@gmail.com < ${LOG_NAME}
}




