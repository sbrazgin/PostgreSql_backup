#!/bin/bash
########################################################################
# Sergey Brazgin     01.2019    IAC DZM
# e-mail:   sbrazgin@gmail.com
# Find base_backup files not older than 3 weeks
# Sort by date
# Use the oldest one as a reference
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

if [ -z ${PGBACKUP_WAL+x} ]; then 
  echo "PGBACKUP_WAL is unset!"
  exit ${GEN_ERR}
fi


cd "${DIR}"


CR_WAL_BACKUP_DIR="${PGBACKUP_WAL}"
OLDEST_BASE_BACKUP=$(basename $(find ${CR_WAL_BACKUP_DIR} -type f -iname "*.backup" -mtime -21 -print0 | xargs -0 ls -t | head -n 1))

echo "newest: ${OLDEST_BASE_BACKUP}"


# Find all subfolders
# Except the u/p backup subfolder
# Execute pg_archivecleanup for each of the subfolders
find $CR_WAL_BACKUP_DIR  -type d  -exec pg_archivecleanup -d {} $OLDEST_BASE_BACKUP \;

