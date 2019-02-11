#!/bin/bash
GEN_ERR=1  # something went wrong in the script


########################################################################
# Sergey Brazgin     12.2018    IAC DZM
# mail:   sbrazgin@gmail.com
########################################################################

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ENV_FILE=".postgres.env.sh"

cd ~
if [ ! -f ${ENV_FILE} ]; then
    echo "File ${ENV_FILE} not found!"
    exit ${GEN_ERR}
fi

source ${ENV_FILE}

cd "${DIR}"

psql -f pg_db_size.sql

