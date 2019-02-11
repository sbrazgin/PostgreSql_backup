#!/bin/bash
########################################################################
# Sergey Brazgin     12.2018    IAC DZM
# e-mail:   sbrazgin@gmail.com
########################################################################

GEN_ERR=1  # something went wrong in the script

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PG_HOME_DIR=`eval echo "~postgres"`

ENV_FILE=".postgres.env.sh"

cd ${PG_HOME_DIR}

if [ ! -f ${ENV_FILE} ]; then
    echo "File ${ENV_FILE} not found!"
    exit ${GEN_ERR}
fi

source ${ENV_FILE}



GEN_ERR=2  # something went wrong in the script
cd "${DIR}"

# log file
LOG_FILE_NAME="${PGBACKUP}/pg_dump_backup.log"
source lib/sblog.sh

if [ -z ${PGBACKUP+x} ]; then 
  echo "PGBACKUP is unset!"
  exit ${GEN_ERR}
fi

if [ -z ${PGBACKUP_REC_WINDOWS_DAY+x} ]; then 
  echo "PGBACKUP_REC_WINDOWS_DAY is unset!"
  exit ${GEN_ERR}
fi



GEN_ERR=3  # something went wrong in the script
cd ${PGBACKUP}

print_log "===================================" 
print_log "Start deleting dump/conf older ${PGBACKUP_REC_WINDOWS_DAY} day"
print_log "" 

print_log "find ${PGBACKUP} -name '*.dat.gz'  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete" 
find ${PGBACKUP} -name "*.dat.gz"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -print | tee -a ${LOG_FILE_NAME}
find ${PGBACKUP} -name "*.dat.gz"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete

print_log "find ${PGBACKUP} -name '*.tar.gz'  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete" 
find ${PGBACKUP} -name "*.tar.gz"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -print | tee -a ${LOG_FILE_NAME}
find ${PGBACKUP} -name "*.tar.gz"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete


print_log "" 
print_log "End deleting dump/conf" 
print_log "===================================" 



if [ -z ${PGBACKUP_FULL+x} ]; then 
  echo "PGBACKUP_FULL is unset!"
  exit ${GEN_ERR}
fi

if [ -z ${PGBACKUP_WAL+x} ]; then 
  echo "PGBACKUP_WAL is unset!"
  exit ${GEN_ERR}
fi

GEN_ERR=4  # something went wrong in the script

print_log "===================================" 
print_log "Start deleting FULL backups older ${PGBACKUP_REC_WINDOWS_DAY} day"
print_log "" 

print_log "find ${PGBACKUP_FULL} -name '*.tar.gz'  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete" 
find ${PGBACKUP_FULL} -name "*.tar.gz"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -print | tee -a ${LOG_FILE_NAME}
find ${PGBACKUP_FULL} -name "*.tar.gz"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete

print_log "find ${PGBACKUP_WAL} -name '0000*'  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete" 
find ${PGBACKUP_WAL} -name "0000*"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -print | tee -a ${LOG_FILE_NAME}
find ${PGBACKUP_WAL} -name "0000*"  -type f -mtime +${PGBACKUP_REC_WINDOWS_DAY} -delete

print_log "" 
print_log "End deleting dump/conf" 
print_log "===================================" 

exit 0

