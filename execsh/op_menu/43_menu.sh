#!/bin/bash

# 指定環境設定檔
. $HOME/execsh/op_menu/set_menu.sh

Run_Menu_No() {
   Run_a=$1
   Run_b=$2
   Run_c=`cat $menu_file | grep ${1}\|${2}`
   set -- $Run_c
   ${exec_path}/$7
   XX=$?
   return $XX
}

check_db() {
   db_return=`Run_Menu_No main 31`
   db_return_status=`echo "$db_return" | grep Success | wc -l`
   db_return_msg=`echo "$db_return" | grep Database`
   if [ $db_return_status -eq 1 ]
   then
      db_status=0
   else
      db_status=1
   fi
}

check_online_ap() {
   online_return=`Run_Menu_No main 22`
   XX=$?
   online_return_status=`echo "$online_return" | grep Success | wc -l`
   online_return_msg=`echo "$online_return" | grep 'AP'`
   if [ $online_return_status -eq 1 ]
   then
      online_status=0
   else
      online_status=1
   fi
}

check_hsm() {
   hsm_return=`Run_Menu_No main 42`
   XX=$?
   hsm_return_status=`echo "$hsm_return" | grep SUCCESS | wc -l`
   hsm_return_msg=`echo "$hsm_return" | grep 'HSM'`
   if [ $hsm_return_status -eq 1 ]
   then
      hsm_status=0
   else
      hsm_status=1
   fi
}

procsignal() {
   echo ""
   exit
}

blink_screen() {
   clear
   echo ""
   echo "  Hostname:$HOSTNAME   --$menu_title--   System Date:`date '+%Y/%m/%d %T'`"
   msg=`/usr/bin/w | /usr/bin/head -1`
   echo "$msg"
   echo ""
   echo "          Monitor Item                   Status"
   echo "    ==========================     ===================="
   echo

   check_db
   check_online_ap
   check_hsm

   if [ "$db_status" = "0" ]
   then
      db_msg="$db_return_msg"
   else
      db_return_msg='Failed'
      db_msg="\033[7m$db_return_msg\033[0m"
   fi

   if [ "$online_status" = "0" ]
   then
      ap_msg="$online_return_msg"
   else
      online_return_msg='Failed'
      ap_msg="\033[7m$online_return_msg\033[0m"
   fi

   if [ "$hsm_status" = "0" ]
   then
      hsm_msg="$hsm_return_msg"
   else
      hsm_return_msg='Failed'
      hsm_msg="\033[7m$hsm_return_msg\033[0m"
   fi

   echo -en "\033[9;5H01. Database status"
   echo -en "\033[9;36H$db_msg"
   echo -en "\033[11;5H02. Online status"
   echo -en "\033[11;36H$ap_msg"
   echo -en "\033[13;5H03. HSM status"
   echo -en "\033[13;36H$hsm_msg"
}

start() {
   echo_idx=1
   while   :
   do
      error_cnt=0
      db_status=0
      online_status=0
      hsm_status=0
      clear
      blink_screen
      error_cnt=`expr $db_status + $online_status + $hsm_status`
      echo -en "\033[22;6HPlease Press Ctrl_C to return to the main menu.............."

      if [ $error_cnt != 0 ];
      then
         sleep 5
         tput bel
         echo_idx=1
         echo -en "\033[22;6H                                            "
         echo -en "\033[19;0H"
      else
         sleep 30
         if [ $echo_idx -eq 1 ];
         then
            echo_idx=0
         else
            echo_idx=1
         fi
      fi

   done
}

trap "procsignal" 2
start
trap 2

