#!/usr/bin/env sh
#This script downloads HDP sandbox along with their proxy docker container
set -x

# CAN EDIT THESE VALUES
registry="hortonworks"
name="sandbox-hdp"
version="3.0.1"
proxyName="sandbox-proxy"
proxyVersion="1.0"
flavor="hdp"

# NO EDITS BEYOND THIS LINE
# housekeeping
echo $flavor > sandbox-flavor


# create necessary folders for nginx and copy over our rule generation script there
mkdir -p sandbox/proxy/conf.d
mkdir -p sandbox/proxy/conf.stream.d

# pull and tag the sandbox and the proxy container
docker pull "$registry/$name:$version"
docker pull "$registry/$proxyName:$proxyVersion"

hostname="sandbox-hdp.hortonworks.com"

version=$(docker images | grep $registry/$name  | awk '{print $2}');

# Create cda docker network
docker network create cda 2>/dev/null

# Create volume for postgres if does not exists
PGSQL_VOLUME=pgsql
MYSQL_VOLUME=mysql
HDFS_VOLUME=hdfs

SCRIPTPATH=`realpath $0`
SCRIPTDIR=`dirname $SCRIPTPATH`

for volume_name in $PGSQL_VOLUME $MYSQL_VOLUME $HDFS_VOLUME
do
    VOLUME_PATH=$SCRIPTDIR/volumes/$volume_name
    mkdir -p $VOLUME_PATH
    echo "Checking $volume_name volume..."; docker volume inspect $volume_name || echo "volume $volume_name does not exist, creating volume..." ;docker volume create --driver local --opt type=none --opt device=$VOLUME_PATH --opt o=bind $volume_name
done

docker run --privileged --name $name -h $hostname --network=cda --network-alias=$hostname \
-v $(pwd)/assets/service-startup.sh:/sandbox/ambari/service-startup.sh \
-v $(pwd)/volumes/backups:/var/backups \
-v $(pwd)/scripts:/var/scripts \
-v $(pwd)/configs/hive-site.jceks:/usr/hdp/current/hive-server2/conf_llap/hive-site.jceks \
-v $(pwd)/volumes/run:/run \
-v $PGSQL_VOLUME:/var/lib/pgsql \
-v $MYSQL_VOLUME:/var/lib/mysql \
-v $HDFS_VOLUME:/hadoop/hdfs \
-d "$registry/$name:$version"


# Deploy the proxy container.
sed 's/sandbox-hdp-security/sandbox-hdp/g' assets/generate-proxy-deploy-script.sh > assets/generate-proxy-deploy-script.sh.new
mv -f assets/generate-proxy-deploy-script.sh.new assets/generate-proxy-deploy-script.sh
chmod +x assets/generate-proxy-deploy-script.sh
assets/generate-proxy-deploy-script.sh 2>/dev/null

#check to see if it's windows
if uname | grep MINGW; then 
 sed -i -e 's/\( \/[a-z]\)/\U\1:/g' sandbox/proxy/proxy-deploy.sh
fi
chmod +x sandbox/proxy/proxy-deploy.sh 2>/dev/null
sandbox/proxy/proxy-deploy.sh 
