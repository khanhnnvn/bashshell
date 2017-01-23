#!/usr/bin/bash

check_service() {
echo "$SVRS"|while read line; do
   IFS=':'
   set -- $line
   unset IFS
   
   [ -z "$1" -o -z "$2" ] && continue
   
   echo | telnet $host_ip $1 2>&1 | \
   grep "Connection to $host_ip closed by foreign host." > /dev/null || {
      echo "`date +"$DATEFMT"` $host_name $host_ip Failed on port $1!! please check it..." >> $LOGFILE
      $2 > /dev/null 2>&1
   }

   echo | telnet $host_ip $1 2>&1 | \
   grep "Connection to $host_ip closed by foreign host." > /dev/null && {
      echo "`date +"$DATEFMT"` $host_name $host_ip port: $1 check is OK~" >> $LOGFILE
      $2 > /dev/null 2>&1
   }
done
echo >> $LOGFILE
}

check_mail_server() {
host_name='Mail_Server'
host_ip='101.99.16.195'
SVRS="
995:echo 'SSL_POP3 daemon needs to check!!(port: 995)'
465:echo 'SSL_SMTP daemon needs to check!!(port: 465)'
110:echo 'POP3 daemon needs to check!!(port: 110)'
25:echo 'SMTP daemon needs to check!!(port: 25)'
"
check_service
}

LOGFILE="./log/svmon_`date +%Y%m%d`.log"
DATEFMT="%Y/%m/%d %R"
check_mail_server