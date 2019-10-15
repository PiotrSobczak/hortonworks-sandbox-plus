set -eu

BACKUP_DIR=/var/backups

LATEST_BACKUP="$BACKUP_DIR/$(ls -t $BACKUP_DIR| head -n 1)"

echo "RESTORING $LATEST_BACKUP" 

ambari-agent stop
ambari-server stop

runuser -l postgres -c '/var/scripts/restore_ambari_db_internal.sh'

ambari-server start
ambari-agent start
