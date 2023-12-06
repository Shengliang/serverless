#!/bin/bash

TableCount=128
EVENTS=0
TIME=300
LUA=otp_read_only
LUA=oltp_write_only
LUA=oltp_insert
LUA=oltp_write_only
LUA=oltp_read_write

MYDBArr=(sbtest1Kx256)
MYDBArr=(sbtest25Kx256)
MYDBArr=(sbtest1Mx256)
MYDBArr=(sbtest1Mx256)

TableSize=25000
TableSize=1000000
TableSizeArr=($TableSize)

source key.sh

export TEST_USER=$USER
export TEST_PASS=$PASS

Cores=(8)
IPArr=($HOST)
IPPort="3306"
export PRIMARY_IP=$IPArr
export PRIMARY_PORT=$IPPort

# Get cluster name from current dir path

ThreadArr=(1000 2 512  4 256 8  128 16 64 32)
ThreadArr=(1000 512 256 128 64 32 16 8 4 2 1)
ThreadArr=(512 256 128 64 32 16 8 4 2 1)
ThreadArr=(256 128 64 32 16 8 4 2 1)
ThreadArr=(128 64 32 16 8 4 2 1)
ThreadArr=(32 16 8 4 2 1)
ThreadArr=(1 2 4 8 16 32 64 64 128 128 256 512 512)
TableArr=(1 2 4 8 16 32 64 64 128 128 128 128 128)

PRE="r$$"

y=0; while  [ $y -le 20 ]; do
c=0
   ((y=y+1))
x=0; while  [ $x -le 12 ]; do
  core=${Cores[0]}
  MYDB=${MYDBArr[0]}
  dbid=${MYDB}
  ThreadCount=${ThreadArr[$x]}
  TableCount=${TableArr[$x]}
  ThreadCount=1000
  TableCount=128
   ((x=x+1))

echo ${PRIMARY_IP}
echo ${PRIMARY_PORT}
 MYSYSBENCH="sysbench --mysql-host=${PRIMARY_IP} --mysql-port=${PRIMARY_PORT} --mysql-password=${TEST_PASS} --mysql-user=${TEST_USER} --db-driver=mysql "

 echo $MYSYSBENCH
LUA=oltp_read_write
 TNOW=`date +%Y%m%d_%H:%M:%S`
 WRFILELOG=${PRE}_wr_${TNOW}_${MYDB}_tableSize_${TableSize}_tableCount_${TableCount}_time_${TIME}_x${x}_threadCount_${ThreadCount}_core_${core}_${dbid}_run.log
 ${MYSYSBENCH} $LUA --threads=$ThreadCount --mysql-db=${MYDB} --tables=${TableCount} --table-size=${TableSize} --events=$EVENTS --time=${TIME} --range_selects=off --db-ps-mode=disable --report-interval=1 run | tee $WRFILELOG
  RC=$?
 ETNOW=`date +%Y%m%d_%H:%M:%S`
 echo RCNOW ${TNOW} ${ETNOW}  ===========================  ${RC}

 exit
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

 exit
 done
done
