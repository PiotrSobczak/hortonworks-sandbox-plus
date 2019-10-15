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

# Stopping and removing hdp sandbox and proxy
```
scripts/clean_hortonworks_containers.sh
```

# Connecting to Hive LLAP
- Add the following line to /etc/hosts
```
<HOST_IP> sandbox-hdp.hortonworks.com
```
- Connect via beeline
```
beeline -n hive -p hive -u "jdbc:hive2://sandbox-hdp.hortonworks.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2"
```

# Enabling Hive LLAP
0.Login as admin on <hostname>:8080/#/login  
1.Enable interactive query  
2.Set the following properties in Hive > Configs  
hive.llap.daemon.yarn.container.mb=32GB   
hive.llap.io.memory.size=2GB  
hive.llap.daemon.num.executors=6  
3.Set llap_heap_size to 25GB in Hive > Configs > Advanced > Advanced hive-interactive-env  
4.Change hive.druid.broker.address.default=broker.druid.dc-2.lb.dcwp.pl:8082 in Hive > Configs > Advanced > Advanced hive-interactive-site  
5.Save configuration  
6.Restart Yarn service  
7.Restart Hive service(may require adding HiveServer2 Interactive component)  


