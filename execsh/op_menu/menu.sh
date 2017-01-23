#!/bin/bash

# 禁止使用者以 Ctrl-? 跳脫選單
trap "" 2 3

# 環境相關設定 --------------------------------------------------------

# 指定環境設定檔
. $HOME/execsh/op_menu/set_menu.sh

# 讀取使用者登入帳號及密碼 --------------------------------------------

# echo "請輸入 OP_MENU 使用帳號: "
echo "OP menu login account: "
# read op_act
op_act=vnpt_op

# echo "請輸入 $op_act 密碼: "
echo "$op_act password: "
stty -echo
# read op_pas
op_pas=vnpt_op123
stty echo
# sleep 3
# echo "a=$op_pas"
# echo "b=$uid_file"

# 確認該帳號是否存在 --------------------------------------------------

# 讀入使用者 key in 的帳號並判斷是否位於密碼表中
op_act_a=$op_act:
# echo $op_acta
read_act=`echo $op_act_a | awk '{print $1}' | xargs -i grep {} $uid_file | cut -f 1 -d :`

# 若該帳號不存在密碼表中則離開
if [ -z $read_act ]
then
   # echo "帳號錯誤，你沒有權限執行 !!"
   echo "Wrong account !!"
   # echo "....................按 <Enter> 繼續 !!...................."
   echo "....................Press <Enter> to continue !!...................."
   read
   exit
fi

# 讀入使用者 key in 帳號的相對應密碼
read_pas=`echo $op_act_a | awk '{print $1}' | xargs -i grep {} $uid_file | cut -f 2 -d :`

# 若該帳號存在密碼表中, 接著判斷密碼是否正確
if [ $op_pas != $read_pas ]
then
   # echo "密碼錯誤，你沒有權限執行 !!"
   echo "Wrong password !!"
   # echo "....................按 <Enter> 繼續 !!...................."
   echo "....................Press <Enter> to continue !!...................."
   read
   exit
fi

if [ "$op_pas" = "$read_pas" ]
 then
   PST1USER=$op_act
   export PST1USER
   PST1PASS=$op_pas
   export PST1PASS

   # echo "aa=$op_act"
   # echo "aa=$op_pas"
   # echo "aa=$PST1USER"
   # echo "aa=$PST1PASS"
   # sleep 1

   # 讀取主選單設定檔檔名
   # 讀入變數, 並確認是否存在於自定群組中
   check_group=`echo $read_act | awk '{print $1}' | xargs -i grep {} $gid_file | cut -f 1 -d :`
   if [ -z $check_group ]
   then
      # echo "你不屬於可執行群組 !!"
      echo "You are not a member of executing group !!"
      # echo "....................按 <Enter> 繼續 !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      exit
   else
      # 秀出使用者所屬的自定群組名
      # echo "你所屬的群組: $check_group"
      # echo "....................按 <Enter> 繼續!!...................."
      # read

      # 依照群組名定義選單設定檔
      # aa=$(eval echo \$$check_group)
      menu_file=$(eval echo \$$check_group)
      export menu_file
      # echo "menu_file 的內容為: $menu_file"
      # echo "....................按 <Enter> 繼續!!...................."
      # read
   fi
fi

# 程式目錄相關設定 ----------------------------------------------------

# 判斷 temp_path 是否存在, 若不存在, 建立之
if [ ! -d $temp_path ]
then
   mkdir -p $temp_path
fi

# ---------------------------------------------------------------------

# 變更到 op_menu  sh 程式目錄
cd $Sh_Dir

# 檢查選項暫存檔,若不存在則建立並設定初始值為1
if [ ! -f $status1_file ]
then
   echo "1" > $status1_file
fi

# menu.conf 檔案格式說明
# 選單名稱|選項編號|行|列|說明|./run_check.sh %1 %2 %3 %4 %5 %6
# %1 確認要執行功能的參數
# %2 確認日期為合理的參數
# %3 檢查是否重複執行的參數
# %4 指定呼叫的 shell 其路徑+檔名
# %5 配合 %3 檢查是否重複執行的 "keyword"
# %6 是否需 su 為其他 user 執行(目前此功能無效)
# 範例: main|21|12|0|顯示目前系統空間|./run_check.sh 1  1  1  ./op_menu/ChkHDSpace1.sh ChkHDSpace1.sh root
#                                                    %1 %2 %3            %4                  %5        %6
# 其中: %1 , %2 , %3 = 1 為真, = 0 為假, 視各個功能項目是否要使用而定
# ----------------------------------------------------------------------
# 若選項編號為0則為顯示說明,請勿輸入執行的命令
# 主選單名稱為 main , 其餘次選單自訂,設定次選單範例如下
# 選單名稱|選項編號|行|列|說明|menu 次選單名稱 0 次選單說明 預選編號
# main|2|12|10|執行指定目錄下的a.sh|./run_check.sh 1 1 1 ./op_menu_new/a.sh a.sh root
# main|0|10|14|查看文件|
# main|5|13|10|批次選單|menu batch 0 批次選單 1
# batch|1|11|10|編輯文件|vi test
# batch|1|11|10|編輯文件|vi test1
# ----------------------------------------------------------------------

menu()
{
   # sleep 5
   rm -f $browfile 1>/dev/null 2>&1
   clear

   # 如果執行選項 2, 33, 63, 則暫時可使用 Ctrl+C 結束作業
   if [ $2 == 43 ]
   then
      trap 2
   else
      trap "" 2
   fi

   [ $2 = "q" ] && return
   echo `
   awk ' BEGIN {
      FS = "|"      # 輸入為 menu main 0 "凌網科技選單"
      if ( "'$2'" == "0" )      # $2 為0
         printf("-en \033[2;26H\033[4m%s\033[0m","'$3'")      # $3 為 凌網科技選單
   }
   {
      if ( "'$2'" == "0" )
      {
         if ( $1 == "'$1'" )
            if ( $2 != "'$5'" )
            {
               if ( $2 != "0" )
               {
                  printf("\033[%s;%sH%s. %s",$3,$4,$2,$5)
               }
               else
               {
                  printf("\033[%s;%sH%s",$3,$4,$5)
               }
            }
            else
            {
               if ( $2 != "0" )
               {
                  printf("\033[%s;%sH\033[7m%s. %s\033[0m",$3,$4,$2,$5)
               }
               else
               {
                  printf("\033[%s;%sH%s",$3,$4,$5)
               }
            }
      }
      else
      {
         if ( $1 == "'$1'" && $2 == "'$2'" )
         {
            printf("%s -> %s . %s",$1,$2,$5) >"'$Log_Temp_File'"
            printf("%s",$6) >"'$browfile'"
         }
      }
   }
   END {
      if ( "'$2'" == "0" )
         # printf( "\033[23;5H %s 請選擇要執行的項目 , 輸入 q 則退出: ","'$4'" )
         printf( "\033[25;5H %s Choose your option, or <q> to quit: ","'$4'" )
   } ' "$menu_file"
   `
   [ -f $browfile ] &&
   {

      echo "" >> $Menu_Log_File
      echo "=======================================" >> $Menu_Log_File
      # echo "執行時間 $run_date" >> $Menu_Log_File
      echo "Executing date $run_date" >> $Menu_Log_File
      # echo "執行選項 `cat $Log_Temp_File` " >> $Menu_Log_File
      echo "Executing item `cat $Log_Temp_File` " >> $Menu_Log_File
      # echo "執行命令 `cat $browfile` " >> $Menu_Log_File
      echo "Executing command `cat $browfile` " >> $Menu_Log_File
      # echo "執行人員帳號 $run_user " >> $Menu_Log_File
      echo "Executing member account $run_user " >> $Menu_Log_File
      # echo "登入人員帳號 $login_user " >> $Menu_Log_File
      echo "Login member account $login_user " >> $Menu_Log_File
      # echo "OP MENU 帳號 $PST1USER " >> $Menu_Log_File
      echo "OP MENU account $PST1USER " >> $Menu_Log_File


      a=`cat $browfile`
      no_a=`cat $Log_Temp_File | awk '{print $1}'`
      # no_a=`cat ${menu_file} | grep "$a" | awk '{print $5}' | cut -f 3 -d \/`
      # echo ${no_a}
      no_b=`cat $Log_Temp_File | awk '{print $3}'`
      # no_b=`cat ${menu_file} | grep "$no_a" | cut -f 1 -d \|`
      # echo ${no_b}
      # no_c=`cat ${menu_file} | grep "$no_a" | cut -f 2 -d \|`
      # echo ${no_c}
      # run_no=${no_b}_${no_c}
      run_no=${no_a}_${no_b}
      # echo $run_no
      export run_no
      # echo "aa=${run_no}"
      # sleep 3
      # $Sh_Dir/$a
      $a
      err=$?
      # echo "執行回應碼 -$err- " >> $Menu_Log_File
      echo "Response code -$err- " >> $Menu_Log_File
      echo "=======================================" >> $Menu_Log_File
      echo "" >> $Menu_Log_File

      if [ $err -eq 0 ]
      then
         rm $browfile 1>/dev/null 2>&1
      else
         # sleep 6
         echo ""
         echo ""
         # echo "=======================系統狀態說明========================="
         echo "=======================System Status========================="
         # echo "選單的執行有問題, 相關資料如下"
         echo "failed execution, the information as below"
         # echo "執行的選單項目"
         echo "Executing item"
         cat $Log_Temp_File
         echo ""
         # echo "執行的命令內容"
         echo "Executing command"
         cat $browfile
         echo ""
         # echo "回應碼 -$err-"
         echo "Response code -$err-"
         rm -f $browfile 1>/dev/null 2>&1
         # echo "....................按任意鍵繼續 !!.........................."
         echo "....................Press any key to continue !!.........................."
         read wait_char
         # exit 1
      fi
   }

   [ $2 = "0" ] || return
   if [ $2 = "0" ]
   then
      read xz
      echo "$xz" > $status1_file
      [ $xz ] || xz="0"
      [ $xz = "q" ] && return
      [ $xz = "0" ] ||
      {
         status1=`cat $status1_file`
         menu $1 $xz $3 $4 $status1
      }
   fi
   status1=`cat $status1_file`
   menu $1 0 $3 $4 $status1
}

# menu main 0 "--$menu_title--(主機:$HOSTNAME)" "(登入帳號:$op_act,群組:$check_group)" 1
menu main 0 "--$menu_title--(Hostname:$HOSTNAME)" "(Account:$op_act,Group:$check_group)" 1

# 如果 UID 為 OP 帳號, 則主選單按 "q" 以後直接登出
if [ "$login_id" = "$run_user" ] && [ -z $USER_EXIT ]
then
   # echo "USER_EXIT=$USER_EXIT="
   # sleep 3
   # ps | grep sh | grep -v grep | awk '{print $1}' | xargs -i kill -9 {} > /dev/null 2>&1
   cd
fi

