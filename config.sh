#!/bin/bash

source key.sh
IP=${HOST}
echo mysql -h $HOST -p${PASS} -u${USER} -P3306
mysql -h $HOST -p${PASS} -u${USER} -P3306 -e "show databases"

export TEST_USER=$USER
export TEST_PASS=$PASS

export PRIMARY_IP=$IP
export PRIMARY_PORT=3306

export MYSYSBENCH="sysbench --mysql-host=${PRIMARY_IP} --mysql-port=${PRIMARY_PORT} --mysql-password=${TEST_PASS} --mysql-user=${TEST_USER} --db-driver=mysql "

function run_sql {
 ip=${PRIMARY_IP}
 echo $ip $#
 if [ "$#" -gt 0 ];
  then
          ip=${1}
       shift
 fi
  echo mysql -u ${TEST_USER} -h ${ip} -P ${PRIMARY_PORT} -p${TEST_PASS} "$@"
  mysql -u ${TEST_USER} -h ${ip} -P ${PRIMARY_PORT} -p${TEST_PASS} "$@"
}

function show_info {
  mysql -u ${TEST_USER} -h ${PRIMARY_IP} -P ${PRIMARY_PORT} -p${TEST_PASS}  -e "show variables"
}

function run_query {
  query=$1
  db=${2:-""}
  mysql -u ${TEST_USER} -h ${PRIMARY_IP} -P ${PRIMARY_PORT} -p${TEST_PASS} $db -e "$query"
}

function wait_for_ready {
query=${1:-"show variables like '%read_only%';"}
time=${2:-1}
for i in {1..1000}
do
        run_query "$query"
        if [ $? == 0 ]; then
                break;
        fi
        sleep $time
done
}
