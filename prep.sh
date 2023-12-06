#!/bin/bash

source key.sh
echo mysql -h $HOST -p${PASS} -u${USER} -P3306
mysql -h $HOST -p${PASS} -u${USER} -P3306 -e "show databases"

IP=${HOST}
CNT=256
source $(dirname $0)/config.sh $IP

MYDB=sbtest1Mx256
TableSize=1000000
TableCount=${CNT}
EVENTS=30
TIME=30
ThreadCount=${TableCount}
ThreadCount=256
LUA=oltp_read_write

#run_query "drop database if exists $MYDB"
run_query "create database $MYDB"
run_query "show databases"

${MYSYSBENCH} $LUA --threads=$ThreadCount --mysql-db=${MYDB} --tables=${TableCount} --table-size=${TableSize} --events=$EVENTS --time=${TIME} prepare
