set -eu

ambari-server stop
ambari-agent stop

PGPASSWORD="bigdata" pg_dump -U ambari ambari > /var/backups/ambari$(date +%Y-%m-%d_%H:%M).sql

ambari-server start
ambari-agent start
