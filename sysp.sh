#!/bin/bash
x=0
echo Workload Date Time database rows tables Time_sec Run_loop Threads Cores vedbmID IP read_cnt write_cnt QPS min_lat avg_lat max_lat 95th_lat
for f in `ls -rt *.log`
do
   g=`echo $f | sed -e "s/_/ /g" | sed -e "s/threadCount//g" | sed -e "s/tableSize//g" | sed -e "s/tableCount//g" | sed -e "s/core //g" | sed -e "s/time //g" | sed -e "s/ run.log//g" | sed -e "s/^a //g"`
   FO=`grep -E "read:|write:|queries:|min:|avg:|max:|95th percentile:" $f | tr -s [:blank:] | sed -e "s/95th percentile/95th_percentile/g" |sed -e "s/ (/_ /g"  |sed -e "s/queries: /queries:_/g" |cut -d' ' -f3 `
   if [ ${#FO} -gt 0 ]
   then
     echo ${g} $FO
   else
     echo ${f} ERROR
   fi
done
