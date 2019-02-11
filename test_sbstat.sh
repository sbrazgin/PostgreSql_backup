source lib/sbstat.sh

# test 1
CURR_DATE=$(sbstat_get_dir_nameD) 
echo "sbstat_get_dir_nameD=${CURR_DATE}"

# test 2
PATH_BACKUP="/u01/backup"
DUMPPATH=$(sbstat_get_dir_nameD2 ${PATH_BACKUP})
echo "sbstat_get_dir_nameD2=${DUMPPATH}"

# test 3
sbstat_set_statusStart ${CURR_DATE} "BACKUP_FULL" 
sbstat_set_statusOK ${CURR_DATE} "BACKUP_FULL" 
echo "--- status.log ---"
cat status.log
echo "--- ---------- ---"

echo "sbstat_set_file_to_del BACKUP_FULL"
sbstat_set_file_to_del "BACKUP_FULL" "3"
code=$?
echo "return code: $code"

#echo "sbstat_set_file_to_del BACKUP_FUL222"
#sbstat_set_file_to_del "BACKUP_FUL222" "3"
#echo "return code: $code"

echo "sbstat_check_today_backup_status BACKUP_FULL"
sbstat_check_today_backup_status
code=$?
echo "return code: $code"
