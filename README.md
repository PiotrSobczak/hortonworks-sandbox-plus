### This repository is an extension of [hortonworks-sandbox](https://www.cloudera.com/downloads/hortonworks-sandbox/hdp.html) which provides additional functionalities:
- Automatic setting admin password for Ambari server
- Starting only needed services(ie. ZOOKEEPER, RANGER, HDFS, YARN, HIVE)
- Persistance of Ambari configuration(bind volume of postgres database directory)
- Persistance of HDFS(bind volume of /hadoop/hdfs directory)
- Persistance of Hive(bind volume of mysql database directory)
- Scripts for Backup and Restore of Ambari configuration

### How to run? Configure your preferences in config.sh and execute:
```
sh docker-deploy-hdp30.sh
```
*Please note that HDP container takes about 5 minutes to start all services

### Cleaning hdp sandbox and proxy containers
```
scripts/clean_hortonworks_containers.sh
```


