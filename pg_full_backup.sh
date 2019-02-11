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

# type
BACKUP_TYPE="FULL_BACKUP"

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

if [ -z ${PGBACKUP_FULL+x} ]; then 
  echo "PGBACKUP_FULL is unset!"
  exit ${GEN_ERR}
fi

if [ -z ${PGBACKUP_WAL+x} ]; then 
  echo "PGBACKUP_WAL is unset!"
  exit ${GEN_ERR}
fi

cd "${DIR}"

# log file
LOG_FILE_NAME="${PGBACKUP_FULL}/pg_full_backup.log"
source lib/sblog.sh
source lib/sbstat.sh

print_log " "
print_log " "
print_log "===================================" 
print_log "Start FULL backup"
print_log "Method: pg_basebackup "               # and clear logs with pg_archivecleanup
print_log "Current environment: "
cd ~
print_log "---" 
cat ${ENV_FILE} >> ${LOG_FILE_NAME}
print_log "---" 
cd "${DIR}"

GEN_ERR=2  # something went wrong in the script

CURR_DATE=$(sbstat_get_dir_nameD) 
DUMPPATH="${PGBACKUP_FULL}/${CURR_DATE}"

print_log "Current date: ${CURR_DATE}"
print_log "Current backup DIR: ${DUMPPATH}"


# add status to file
cd "${DIR}"
sbstat_set_statusStart "${CURR_DATE}" "${BACKUP_TYPE}"

mkdir -p $DUMPPATH

GEN_ERR=3  # something went wrong in the script

#pg_basebackup -R -D ${DUMPPATH} | tee pg_basebackup_out.log
pg_basebackup -D ${DUMPPATH} -Ft -z -P   
code=$?

if [ $code -ne 0 ]; then
    print_log "The backup pg_basebackup failed (exit code $code), check for errors"
    exit ${GEN_ERR}
fi

#cat pg_basebackup_out.log >> ${LOG_FILE_NAME}
 
GEN_ERR=4  # something went wrong in the script

print_log "---------------------" 
print_log " " 
print_log "End" 
print_log "===================================" 

# add status to file
cd "${DIR}"
sbstat_set_statusOK "${CURR_DATE}" "${BACKUP_TYPE}"
#echo "${CURR_DATE} FULL OK" | tee status.log

exit 0


