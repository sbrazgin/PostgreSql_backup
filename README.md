# bash-������� ��� ������� ������ PostgreSql-��� ������
=================

pg_db_backup.sh	  - �������� �����	

pg_full_backup.sh - ������ ������

pg_backup_old_delete.sh - �������� ���������� �������

pg_backup_copy.sh	- ����������� �� ��������� ������

�������� � cron:

 0     21      *      *      *      /var/lib/postgresql/scripts/backup/pg_db_backup.sh
 30    *       *      *      *      /var/lib/postgresql/scripts/backup/pg_backup_copy.sh
 0     23      *      *      *      /var/lib/postgresql/scripts/backup/pg_backup_old_delete.sh
 0     22      *      *      *      /var/lib/postgresql/scripts/backup/pg_full_backup.sh

