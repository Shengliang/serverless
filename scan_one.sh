#!/bin/bash

TableCount=128
EVENTS=0
TIME=30
LUA=otp_read_only
LUA=oltp_write_only
LUA=oltp_insert
LUA=oltp_write_only
LUA=oltp_read_write

MYDBArr=(sbtest)
TableSizeArr=(5000)

source key.sh

export TEST_USER=$USER
export TEST_PASS=$PASS

Cores=(1)
IPArr=($HOST)
IPPort="3306"
export PRIMARY_IP=$IPArr
export PRIMARY_PORT=$IPPort

# Get cluster name from current dir path

ThreadArr=(1000 2 512  4 256 8  128 16 64 32)
ThreadArr=(1 2 4 8 16 32 64 128 256 512 1000)
ThreadArr=(1000 512 256 128 64 32 16 8 4 2 1)
ThreadArr=(512 256 128 64 32 16 8 4 2 1)
ThreadArr=(256 128 64 32 16 8 4 2 1)
ThreadArr=(128 64 32 16 8 4 2 1)
ThreadArr=(90 64 32 16 8 4 2 1)

PRE="r$$"

y=0; while  [ $y -le 20 ]; do
c=0
   ((y=y+1))
  TableCount=$y
x=0; while  [ $x -le 32 ]; do
   ((x=x+1))
  core=${Cores[0]}
  MYDB=${MYDBArr[0]}
  dbid=${MYDB}
  TableSize=5000
  #ThreadCount=${ThreadArr[$x]}
  #TableCount=128
  #ThreadCount=128
  TableCount=$x
  ThreadCount=$x

echo ${PRIMARY_IP}
echo ${PRIMARY_PORT}
 MYSYSBENCH="sysbench --mysql-host=${PRIMARY_IP} --mysql-port=${PRIMARY_PORT} --mysql-password=${TEST_PASS} --mysql-user=${TEST_USER} --db-driver=mysql "

 echo $MYSYSBENCH
LUA=oltp_read_only
 TNOW=`date +%Y%m%d_%H:%M:%S`
 ROFILELOG=${PRE}_ro_${TNOW}_${MYDB}_tableSize_${TableSize}_tableCount_${TableCount}_time_${TIME}_x${x}_threadCount_${ThreadCount}_core_${core}_${dbid}_run.log
 echo ${ROFILELOG}
  ${MYSYSBENCH} $LUA --threads=$ThreadCount --mysql-db=${MYDB} --tables=${TableCount} --table-size=${TableSize} --events=$EVENTS --time=${TIME} --range_selects=off --db-ps-mode=disable --report-interval=1 --skip-trx run | tee $ROFILELOG
  RC=$?
 ETNOW=`date +%Y%m%d_%H:%M:%S`
 echo RCNOW ${TNOW} ${ETNOW}  ===========================  ${RC}


LUA=oltp_write_only
 TNOW=`date +%Y%m%d_%H:%M:%S`
 WOFILELOG=${PRE}_wo_${TNOW}_${MYDB}_tableSize_${TableSize}_tableCount_${TableCount}_time_${TIME}_x${x}_threadCount_${ThreadCount}_core_${core}_${dbid}_run.log
   ${MYSYSBENCH} $LUA --threads=$ThreadCount --mysql-db=${MYDB} --tables=${TableCount} --table-size=${TableSize} --events=$EVENTS --time=${TIME} --range_selects=off --db-ps-mode=disable --report-interval=1 run | tee $WOFILELOG
  RC=$?
 ETNOW=`date +%Y%m%d_%H:%M:%S`
  echo RCNOW ${TNOW} ${ETNOW}  ===========================  ${RC}
LUA=oltp_read_write
 TNOW=`date +%Y%m%d_%H:%M:%S`
 WRFILELOG=${PRE}_wr_${TNOW}_${MYDB}_tableSize_${TableSize}_tableCount_${TableCount}_time_${TIME}_x${x}_threadCount_${ThreadCount}_core_${core}_${dbid}_run.log
 ${MYSYSBENCH} $LUA --threads=$ThreadCount --mysql-db=${MYDB} --tables=${TableCount} --table-size=${TableSize} --events=$EVENTS --time=${TIME} --range_selects=off --db-ps-mode=disable --report-interval=1 run | tee $WRFILELOG
  RC=$?
 ETNOW=`date +%Y%m%d_%H:%M:%S`
 echo RCNOW ${TNOW} ${ETNOW}  ===========================  ${RC}


 done
exit
done
