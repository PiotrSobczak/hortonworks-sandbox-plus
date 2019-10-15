# This is basically a fork of of [hortonworks-sandbox](https://www.cloudera.com/downloads/hortonworks-sandbox/hdp.html) extended by:
- Automatic setting admin password for Ambari server
- Starting only needed services(ZOOKEEPER, RANGER, HDFS, YARN, HIVE)
- Persistance of Ambari configuration(bind volume of postgres database directory)
- Scripts for Backup and Restore of Ambari configuration
- Persistance of HDFS(bind volume of /hadoop/hdfs directory)
- Persistance of Hive(bind volume of mysql database directory)

# How to run? HDP container takes about 5 minutes to start all services.
```
sh docker-deploy-hdp30.sh
```

# Cleaning hdp sandbox and proxy containers
```
scripts/clean_hortonworks_containers.sh
```


