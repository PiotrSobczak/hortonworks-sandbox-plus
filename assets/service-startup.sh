#!/usr/bin/env bash

set -x

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# RESTARTING AMBARI AGENT AND SERVER DUE TO MOUNTING POSTGRES DIR
systemctl restart ambari-server && systemctl restart ambari-agent

# WAITING FOR AMBARI REST API TO COME UP
until curl --silent -u raj_ops:raj_ops -H 'X-Requested-By:ambari' -i -X GET  http://localhost:8080/api/v1/clusters/Sandbox/hosts/sandbox-hdp.hortonworks.com/host_components/ZOOKEEPER_SERVER | grep state | grep -v desired | grep INSTALLED; do sleep 5; done;

# REMOVING OLD POSTGRES RUN FILES FROM SANDBOX
rm -rf /var/run/postgresql/*
systemctl restart postgresql-9.6.service

# RESTORING AMBARI DATABASE FROM LATEST DUMP
#/var/scripts/restore_ambari_db.sh

# SETTING AMBARI ADMIN USER
printf 'admin\nadmin' | ambari-admin-password-reset

systemctl restart ambari-server

# WAITING FOR AMBARI REST API TO COME UP
until curl --silent -u raj_ops:raj_ops -H 'X-Requested-By:ambari' -i -X GET  http://localhost:8080/api/v1/clusters/Sandbox/hosts/sandbox-hdp.hortonworks.com/host_components/ZOOKEEPER_SERVER | grep state | grep -v desired | grep INSTALLED; do sleep 5; done;

# STARTING CHOSEN SERVICES
for service in RANGER ZOOKEEPER HDFS YARN HIVE;
do
  curl -u admin:admin -H "X-Requested-By: ambari" -X PUT -d '{"RequestInfo": {"context" :"Start '$service'"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://localhost:8080/api/v1/clusters/Sandbox/services/$service | python /sandbox/ambari/wait-until-done.py
done

