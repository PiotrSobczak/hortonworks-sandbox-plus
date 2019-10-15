
set -eu

BACKUP_DIR=/var/backups

LATEST_BACKUP="$BACKUP_DIR/$(ls -t $BACKUP_DIR| head -n 1)"

echo "RESTORING $LATEST_BACKUP"

export PGPASSWORD="bigdata"

psql -c 'DROP DATABASE ambari'
psql -c 'CREATE DATABASE ambari'
psql -d ambari -f $LATEST_BACKUP >> /dev/null
