
containers=$(docker ps -a | grep "hortonworks" | awk '{print $1}' | tr '\n' ' ')

num_containers=$(docker ps -a | grep "hortonworks" | awk '{print $1}' | wc -l)

echo "Removing $num_containers containers: [$containers]"

for a in $containers;do echo "Stopping $a"; docker stop $a; echo "Removing $a"; docker rm $a; done
