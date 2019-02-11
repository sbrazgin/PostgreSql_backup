# bash-скрипты для ручного бэкапа PostgreSql-баз данных
=================

pg_db_backup.sh	  - Создание дампа	

pg_full_backup.sh - Полный бэкапа

pg_backup_old_delete.sh - Удаление устаревших бэкапов

pg_backup_copy.sh	- Копирование на удаленный сервер

Добавить в cron:

 0     21      *      *      *      /var/lib/postgresql/scripts/backup/pg_db_backup.sh
 30    *       *      *      *      /var/lib/postgresql/scripts/backup/pg_backup_copy.sh
 0     23      *      *      *      /var/lib/postgresql/scripts/backup/pg_backup_old_delete.sh
 0     22      *      *      *      /var/lib/postgresql/scripts/backup/pg_full_backup.sh

