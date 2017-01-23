#!/usr/bin/bash

. ~/.profile

cd /etc/ha/monitor
# ./psmon.sh
./spacemon.sh
./svmon.sh

date_name=`date +%Y%m%d`

if [ -f ./log/spacemon_${date_name}.log ] && [ -f ./log/svmon_${date_name}.log ]
then
   echo "Starting send mail.."
   ./send_mail.sh
else
   echo "Log is not ready!!"
fi

