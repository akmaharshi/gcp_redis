#!/bin/bash

function Usage
{
	printf " "
	printf " Usage: $0 <REDIS PORT>\n"
	printf " "
	printf " "
}

function ExecutionComplete
{
    printf "+++++++++++++++++ $0 SCRIPT COMPLETED AT `date` +++++++++++++++++\n"
    exit 1
}

timeStamp=`date '+%m_%d_%y_%H_%M_%S'`
logFile="/tmp/backup_restore_log_${timeStamp}.log"

printf "+++++++++++++++++ $0 SCRIPT STARTED AT `date` +++++++++++++++++\n"

REDIS_PORT=$1
if [ -z "$1" ]; then
  Usage
  ExecutionComplete
fi

VALID_REDIS_PORTS="6379 6380 6381 6382 6383 6384 6385 6386 6387 6388 6389 6390 6391 6392 6393 6394 6395 6400"
if [[ ! " ${VALID_REDIS_PORTS[@]} " =~ " ${REDIS_PORT} " ]]; then
    printf "\t Not a valid redis port"
    ExecutionComplete
fi

case "$REDIS_PORT" in
    "6379") master_hosts="us-east4-a:test-redis1" slave_hosts="us-east4-a:test-redis2"
    ;;
    "6380") master_hosts="us-east4-a:test-redis3" slave_hosts="us-east4-a:test-redis4"
    ;;
    "6381") master_hosts="us-east4-a:test-redis5" slave_hosts="us-east4-a:test-redis6"
    ;;
    "6382") master_hosts="us-east4-b:test-redis7" slave_hosts="us-east4-b:test-redis8"
    ;;
    "6383") master_hosts="us-east4-b:test-redis9" slave_hosts="us-east4-b:test-redis10"
    ;;
    "6384") master_hosts="us-east4-c:test-redis11" slave_hosts="us-east4-c:test-redis12"
    ;;
    "6385") master_hosts="us-east4-c:test-redis13" slave_hosts="us-east4-c:test-redis14"
    ;;
esac

project_id="esd-runscope-prd"

for host in ${master_hosts}; do
    master_zone=$(echo $host | awk -F':' '{print $1}')
    master_host=$(echo $host | awk -F':' '{print $2}')
    
    printf "\t### Connecting to ${master_zone}:${master_host} with ${project_id} ###\n"
    #gcloud beta compute ssh --zone "${master_zone}" "${master_host}" --project "${project_id}" -- 'sudo su - ;/usr/local/runscope/redis/myredis.sh ${REDIS_PORT};sleep 5;exit;exit'
    ssh -t user@$master_host "sudo /usr/local/runscope/redis/myredis.sh ${REDIS_PORT};sleep 5"
done

for host in ${slave_hosts}; do
    slave_zone=$(echo $host | awk -F':' '{print $1}')
    slave_host=$(echo $host | awk -F':' '{print $2}')
    
    printf "\t### ${slave_zone}:${slave_host} with ${project_id} ###\n"
    #gcloud beta compute ssh --zone "${slave_zone}" "${slave_host}" --project "${project_id}" -- 'sudo su - ;/usr/local/runscope/redis/myredis.sh ${REDIS_PORT};sleep 5;exit;exit'    
    ssh -t user@$slave_host "sudo /usr/local/runscope/redis/myredis.sh ${REDIS_PORT};sleep 5"
done
