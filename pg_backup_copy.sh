#!/bin/bash
########################################################################
# copy all backup to remote server
# Sergey Brazgin     01.2019    IAC DZM
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
if [ -z ${PGBACKUP+x} ]; then 
  echo "PGBACKUP is unset!"
  exit ${GEN_ERR}
fi

if [ -z ${PGBACKUP_REMOTE+x} ]; then 
  echo "PGBACKUP_REMOTE is unset!"
  exit ${GEN_ERR}
fi


# set START status
cd "${DIR}"
LOG_FILE_NAME="${PGBACKUP}/backups_copy.log"
source lib/sblog.sh
source lib/sbstat.sh

CURR_DATE=$(sbstat_get_dir_nameD) 
BACKUP_TYPE="BACKUPS_COPY_TO"
sbstat_set_statusStart "${CURR_DATE}" "${BACKUP_TYPE}"

print_log "-------------------------------------------------------"
print_log  "Start copy from ${PGBACKUP}/ to ${PGBACKUP_REMOTE}"   
print_log  " " 

# RSYNC 1
rsync -azP "${PGBACKUP}/" "${PGBACKUP_REMOTE}" >>${LOG_FILE_NAME} 


# RSYNC 2
if [ -z ${PGBACKUP_FULL+x} ]; then 
  print_log  "PGBACKUP_FULL is unset!"  
else
  print_log  "Start copy from ${PGBACKUP_FULL}/ to ${PGBACKUP_REMOTE}"   
  print_log  " " 
  rsync -azP "${PGBACKUP_FULL}/" "${PGBACKUP_REMOTE}" >>${LOG_FILE_NAME} 
fi


# RSYNC 3
if [ -z ${PGBACKUP_WAL+x} ]; then 
  print_log  "PGBACKUP_WAL is unset!" 
else  
  print_log  "Start copy from ${PGBACKUP_WAL}/ to ${PGBACKUP_REMOTE}"   
  print_log  " " 
  rsync -azP "${PGBACKUP_WAL}/" "${PGBACKUP_REMOTE}" >>${LOG_FILE_NAME} 
fi

# set FINISH status
cd "${DIR}"
sbstat_set_statusOK "${CURR_DATE}" "${BACKUP_TYPE}"

print_log " " 
print_log "End copy" 
print_log "-------------------------------------------------------"

exit 0
