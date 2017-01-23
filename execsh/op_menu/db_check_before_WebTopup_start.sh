#!/usr/bin/ksh

x=0
y=1
while [ $x -eq 0 ]
do
   echo "Checking DB connection.....The number of times: $y"
   db_status=`/op_webtopup/execsh/op_menu/DbConnTest.sh | grep status | awk '{print $4}'`
   if [ $db_status == Success ]
   then
      echo "DB connection: Success"
      echo "Prepare to start WebTopup AP....."
      echo "Starting WebTopup Service"
      cd /op_webtopup/Host/;./runOnlineNohup.sh
      x=1
   else
      echo "DB connection: Fail"
      x=0
   fi
   y=`echo "$y + 1" | bc`
done

