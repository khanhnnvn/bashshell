#!/usr/bin/bash

HOME_BASE=/etc/ha/monitor

### Relay Mail Srv Cfg
SRV_IP="222.255.28.217"
SRV_PORT=25

### Current Srv Cfg
SYS_NO="hvt_test@vnptepay.com.vn"
SYS_NAME=`hostname`
SYS_IP=172.16.8.52

MAIL_FILE=${HOME_BASE}/mail_list.cfg
LINE_NUM=`wc -l $MAIL_FILE | awk '{print $1}'`

date_name=`date +%Y%m%d`
cur_date=`date +%Y/%m/%d`_`date +%T`

# mail_msg1=${HOME_BASE}/log/psmon_${date_name}.log
mail_msg2=${HOME_BASE}/log/spacemon_${date_name}.log
mail_msg3=${HOME_BASE}/log/svmon_${date_name}.log


mail_pat()
{
  echo "Subject: VNPT EPAY Server Information--    $cur_date"
  echo ""
  echo "---------------------------------------------------------"
  echo "Host Name: $SYS_NAME"
  echo "Host IP: $SYS_IP"
  echo ""
  echo "System Messages:"
  echo "Local Host File System Usage Warning List:"
  cat $mail_msg2
  echo ""
  echo "Remote Host Connection Warning List:"
  cat $mail_msg3
  echo "---------------------------------------------------------"
}

tpipe()
{
sleep 1
echo "EHLO vnptepay.com.vn"
sleep 1
echo "AUTH LOGIN"
sleep 1
echo "ZXB1cnNlQHZucHRlcGF5LmNvbS52bg=="
sleep 1
echo "aHl3ZWIhQCM="
sleep 1
echo "MAIL FROM:<$SYS_NO>"
sleep 1

### 寄信給收信者
num=0
while (test $num -lt $LINE_NUM)
do
   num=`expr $num + 1`
   MAIL_ADDR=`head -$num $MAIL_FILE | tail -1`
   echo "RCPT TO:<$MAIL_ADDR>"
   sleep 1
done

echo "DATA"
sleep 1
mail_pat
echo "."
sleep 1
echo "QUIT"
sleep 1
}

echo "寄送 smtp mail Begin------------------->"
tpipe | telnet $SRV_IP $SRV_PORT
echo "寄送 smtp mail End--------------------->"

