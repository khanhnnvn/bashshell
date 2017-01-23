#!/usr/bin/bash

USED_SPACE=80

LOGFILE="./log/spacemon_`date +%Y%m%d`.log"
DATEFMT=`date "+%Y/%m/%d %R"`

df -k >> $LOGFILE
df -k | egrep '[0-9]%' | \
while read line; do
   set -- $line

   [ `echo $5 | cut -f1 -d%` -gt $USED_SPACE ] && {
      echo "`date +"$DATEFMT"` `hostname` $1 file system usage has exceeded 80% --> $5 " >> $LOGFILE
   }
done

