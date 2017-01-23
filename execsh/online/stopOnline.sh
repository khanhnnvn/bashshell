#!/bin/sh

cd $WORK_DIR

for pid in `ps -ef | grep -v grep | grep "java -Dlog4j.configuration=config/loyaltys/log4.xml" | awk '{print $2}'`
   do
      if test -n $pid
      then
         echo "Kill PID=$pid "
         kill $pid
      fi
   done


