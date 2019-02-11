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


if [ -z ${PGBACKUP_FULL+x} ]; then 
  echo "PGBACKUP_FULL is unset!"
  exit ${GEN_ERR}
fi

cd "${DIR}"

cd ${PGBACKUP_FULL}

find  -maxdepth 1 -type d ! -wholename $(find  ! -wholename "." -type d -printf '%T+ %p\n' | sort -r | head -1 | cut -d" " -f2) ! -wholename "." -exec rm -r {} +

