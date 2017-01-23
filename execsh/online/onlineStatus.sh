#!/usr/bin/sh

cd $WORK_DIR

connect_ip=`grep 'server.ip=' $HOME/Host/config/loyaltys/ip.properties | grep -v grep | sed 's/server.ip=//'`

connect_port=`grep 'server.port=' $HOME/Host/config/loyaltys/ip.properties | grep -v grep | sed 's/server.port=//'`

numRemote=`netstat -an | grep LISTEN | grep -v grep | grep $connect_ip.$connect_port | wc -l`

if [ "$numRemote" -ge 1 ]; then
   echo
   echo "AP [$connect_ip:$connect_port] status:Success"
   echo
else
   echo
   echo "AP [$connect_ip:$connect_port] status:\033[41mFailed\033[0m"
   echo
fi

