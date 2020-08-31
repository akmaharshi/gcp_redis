#!/bin/bash
if [ -z "$1" ]; then
  REDIS_PORT=6379
else
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    REDIS_PORT="$1"
  else
    printf "Syntax: $0 <port>"
    printf "Port number is optional, defaults to 6379."
    exit 1
  fi
fi

HOSTNAME=`hostname | cut -f 1 -d '.'`
timeStamp=`date '+%m_%d_%y_%H_%M_%S'`
logFile="/tmp/redis_backup_${HOSTNAME}_${timeStamp}.log"

project_id="esd-runscope-prd"

REDIS_CLI="/usr/bin/env redis-cli -h ${HOSTNAME} -p ${REDIS_PORT}"
REDIS_ROLE=`${REDIS_CLI} info | grep ^role: | cut -f 2 -d ':'`

if [[ "${REDIS_ROLE}" == "master" ]]; then
    SLAVE_NAME=`${REDIS_CLI} info | grep slave0 | cut -f 2 -d '=' |  cut -f 1 -d ',' `
    ${REDIS_CLI} slaveof ${SLAVE_NAME} ${REDIS_PORT}
else 
    ${REDIS_CLI} slaveof no one
    printf "Converted Slave host to master" >> $logFile
fi
