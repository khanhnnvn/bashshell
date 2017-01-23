#!/usr/bin/bash

SVRS="
syslogd:echo 'SYSLOG daemon needs to restart'
httpd:echo 'HTTP daemon needs to restart'
yesd:echo 'YES daemon needs to restart'
"

LOGFILE="./log/psmon_`date +%Y%m%d`.log"
DATEFMT=`date "+%Y/%m/%d %R"`

echo "$SVRS" | while read line; do

   IFS=':'
   set -- $line
   unset IFS

   [ -z "$1" -o -z "$2" ] && continue

   ps -ef | grep $1 > /dev/null || {
      echo "`date +"$DATEFMT"` `hostname` $1 has Failed!!, please check..." >> $LOGFILE
   }

   ps -ef | grep $1 > /dev/null && {
      echo "`date +"$DATEFMT"` `hostname` $1 service is OK~" >> $LOGFILE
   }

done

