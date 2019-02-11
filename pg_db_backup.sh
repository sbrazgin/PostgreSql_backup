#!/bin/bash
########################################################################
# Sergey Brazgin     12.2018    IAC DZM
# e-mail:   sbrazgin@gmail.com
########################################################################

GEN_ERR=1  # something went wrong in the script

# current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# need script ...env.sh for setting env
ENV_FILE=".postgres.env.sh"

cd ~
if [ ! -f ${ENV_FILE} ]; then
    echo "File ${ENV_FILE} not found!"
    exit ${GEN_ERR}
fi

source ${ENV_FILE}

# check var exists 
if [ -z ${PGDATA+x} ]; then 
  echo "PGDATA is unset!"
  exit ${GEN_ERR}
fi

if [ -z ${PGBACKUP+x} ]; then 
  echo "PGBACKUP is unset!"
  exit ${GEN_ERR}
fi

if [ -z ${PGBACKUP_DBTYPE+x} ]; then 
  echo "PGBACKUP_DBTYPE is unset!"
  exit ${GEN_ERR}
fi


cd "${DIR}"

# log file
#LOG_FILE_NAME="${DIR}/pg_dump_backup.log"
LOG_FILE_NAME="${PGBACKUP}/pg_dump_backup.log"
source lib/sblog.sh
source lib/sbstat.sh

print_log " "
print_log " "
print_log "===================================" 
print_log "Start backup"
print_log "Method: Dump PG DB and conf files" 
print_log "Current environment: "
cd ~
print_log "---" 
cat ${ENV_FILE} >> ${LOG_FILE_NAME}
print_log "---" 
cd "${DIR}"

GEN_ERR=2  # something went wrong in the script

CURR_DATE=$(sbstat_get_dir_nameD) 
DUMPPATH="${PGBACKUP}/${CURR_DATE}"
ConfFile="${DUMPPATH}/config.tar.gz"
BACKUP_TYPE="DUMP_BACKUP"

print_log "Current date: ${CURR_DATE}"
print_log "Current backup DIR: ${DUMPPATH}"

sbstat_set_statusStart "${CURR_DATE}" "${BACKUP_TYPE}"

mkdir -p $DUMPPATH
cd ${DUMPPATH}

psql -t -A -c 'SELECT datname FROM pg_database' |grep -v template > list_pg_db.log

print_log "-------------------------------------------------------"
print_log "List of databases: " 
print_log "-------------------- " 
cat list_pg_db.log
cat list_pg_db.log >>  ${LOG_FILE_NAME}
print_log "-------------------- " 

COUNTER=0

GEN_ERR=3  # something went wrong in the script

while read p; do
  #echo "$p"
  print_log "-------------------------------------------------------"
  print_log  "Start dumping database: ${p}" 
  print_log  " " 
  
  DumpFile="${DUMPPATH}/${p}"
  mkdir -p ${DumpFile}

  code=3

  if [ "${PGBACKUP_DBTYPE}" == "BIG" ]
  then
    pg_dump -v -j 8 -F d -f ${DumpFile} "$p" >>${LOG_FILE_NAME} 
    code=$?
  fi  
  if [ "${PGBACKUP_DBTYPE}" == "MEDIUM" ]
  then
    DumpFile="${DUMPPATH}/${p}/${p}.tar.gz"
    pg_dump -v -F c -f ${DumpFile} "$p" >>${LOG_FILE_NAME} 
    code=$?
  fi  
  if [ "${PGBACKUP_DBTYPE}" == "SMALL" ]
  then
    DumpFile="${DUMPPATH}/${p}/${p}.sql"
    pg_dump -v -f ${DumpFile} "$p" >>${LOG_FILE_NAME} 
    code=$?
  fi  



  if [ $code -ne 0 ]; then
    print_log "The backup pg_dump failed (exit code $code), check for errors"
    exit ${GEN_ERR}
  fi

  COUNTER=$[$COUNTER +1]

done <list_pg_db.log

GEN_ERR=4  # something went wrong in the script

# for disable compress : --compress=0
print_log "---------------------" 
print_log " " 
print_log "End dumping" 
print_log "---------------------" 
print_log "Start backuping config files" 
print_log " " 
print_log "tar -cvzf ${ConfFile} ${PGDATA}/*.conf" 

tar -cvzf ${ConfFile} ${PGDATA}/*.conf >> ${LOG_FILE_NAME}
code=$?

if [ $code -ne 0 ]; then
    print_log "The tar config files failed (exit code $code), check for errors"
    exit ${GEN_ERR}
fi

print_log ""
print_log "End backuping" 
print_log "===================================" 

# add status to file
if (( COUNTER > 0 )); then      
  cd "${DIR}"
  sbstat_set_statusOK "${CURR_DATE}" "${BACKUP_TYPE}"
fi

exit 0


