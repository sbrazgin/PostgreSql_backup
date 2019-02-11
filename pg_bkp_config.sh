#!/bin/bash
GEN_ERR=1  # something went wrong in the script


########################################################################
# Sergey Brazgin     12.2018    IAC DZM
# mail:   sbrazgin@gmail.com
########################################################################

if [ $# -eq 0 ] 
   then
    echo "No arguments supplied!"
    echo "use: pg_bkp_config.sh [setDBconnect] [checkDBconnect] [setBackupDIR] [checkBackupDIR] options"
	echo " "
    echo "example: "
	echo "  pg_bkp_config.sh setDBconnect PGDBNAME test_so1_mcab_db "
	echo "  pg_bkp_config.sh setDBconnect PGDATA /u01/postgresql_test/data"
	echo "  pg_bkp_config.sh setDBconnect PGHOME /usr/lib/postgresql96"
	echo "  pg_bkp_config.sh setDBconnect PGPORT 5432"
	echo " "
    echo "  pg_bkp_config.sh setBackupDIR PGBACKUP /u01/postgresql_test/pg_db_backup"
	echo " "
	echo "  pg_bkp_config.sh checkDBconnect"
	echo " "
	echo "  pg_bkp_config.sh checkBackupDIR"
    exit
fi

LOG_FILE_NAME="/home/postgres/pg_backup.log"
source lib/sblog.sh

CONFIG_FILE="/home/postgres/.pg_db_env.sh"

runUpdateConfig=false;
runCheckDbConnect=false;
runCheckBackupDir=false;


arg="$1"
case "$arg" in
	"setDBconnect")
		runUpdateConfig=true
		;;
	"setBackupDIR")
		runUpdateConfig=true
		;;
	"checkDBconnect")
		runCheckDbConnect=true
		;;
	"checkBackupDIR")
		runCheckBackupDir=true
		;;
	-disableTest)
		disableTest=true
		;;
	-disableUpdate)
		disableUpdate=true
		;;
	*)
		nothing="true"
		;;
esac

if [[ $runUpdateConfig = true ]] 
  then
    TARGET_KEY="$2"
	REPLACEMENT_VALUE="$3"
	print_log "Change param: ${TARGET_KEY} = ${REPLACEMENT_VALUE}"
	touch $CONFIG_FILE
	# delete
    if grep -q "$TARGET_KEY" $CONFIG_FILE
	then
	  #echo "exist"
	  sed -i.bak "/${TARGET_KEY}/d" $CONFIG_FILE
	fi  
	# add
    echo "export ${TARGET_KEY}=${REPLACEMENT_VALUE}" >> $CONFIG_FILE      
	echo "------" >> ${LOG_FILE_NAME}
	cat ${CONFIG_FILE} >> ${LOG_FILE_NAME}
	echo "------" >> ${LOG_FILE_NAME}
fi

if [[ $runCheckDbConnect = true ]] 
  then
  source ${CONFIG_FILE}
  if pg_isready -h localhost -p ${PGPORT}
  then
    print_log "Check connection OK" 
  else 	
    print_log "Check connection ERROR !" 
  fi
fi

if [[ $runCheckBackupDir = true ]] 
  then
  source ${CONFIG_FILE}
  if mkdir -p ${PGBACKUP}
  then
    print_log "Check catalog ${PGBACKUP} OK" 
  else 	
    print_log "Check catalog ${PGBACKUP} ERROR" 
  fi
  
fi  



  
exit 0

