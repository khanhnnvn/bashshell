#!/usr/bin/bash

# 禁止使用者以 Ctrl-? 跳脫選單

# 環境相關設定 --------------------------------------------------------

# 環境設定檔

# 程式目錄相關設定 ----------------------------------------------------

# 讀取執行主程式的目錄路徑

. $HOME/execsh/op_menu/set_menu.sh

# Temp 目錄相關設定 ---------------------------------------------------

# 讀取程式 temp 的目錄路徑

# 判斷 temp_path 是否存在, 若不存在, 建立之
if [ ! -d $temp_path ]
then
   mkdir -p $temp_path
fi

# 依照 username 及 pts 定義 temp log name
# user_part1=`who am i | awk '{print $1}'`
# user_part2=`who am i | awk '{print $2}' | sed -e 's/\///'`
# user_full=${user_part1}_${user_part2}

# 設定 log 暫存檔名稱
# Log_Temp_File=${temp_path}/${user_full}_menu-temp.log

# Log 目錄相關設定 ----------------------------------------------------

# 設定時間來命名 log 檔名
# log_date=`date +%Y%m%d`

# 讀取程式 log 的目錄路徑

# 讀取 log 檔案名稱

# ---------------------------------------------------------------------

# 變更到執行程式的主目錄
cd $exec_path

# 讓使用者知道目前的執行項目
cat $Log_Temp_File
echo

# 顯示由 op menu 帶進來的參數值
# echo
# echo "$1 $2 $3 $4 $5 $6"

# all = 所有參數(檢查是否重複執行用)
# all="$1|$2|$3|$4|$5|$6"
# keyword = 要檢查是否重複的關鍵字
keyword=$5

# ------------------------------------------------------------------------

# 確認要執行函式
confirm() {
   # 確認函式
   # 確認使用者要執行命令
   #
   # echo "確認要執行程式? (Yy/Nn): "
   echo "Are you sure to execute? (Yy/Nn): "
   read tans
   if [ -n "$tans" ] && [ $tans = "y" -o $tans = "Y" ]
   then
      # clear
      # echo "確認執行!"
      echo ""
   else
      # clear
      # echo "後悔執行!"
      echo "---------------------------------------" >> $Menu_Log_File
      # echo "使用者後悔執行, 指令未執行 !!" >> $Menu_Log_File
      echo "User abandoned !!" >> $Menu_Log_File
      echo "---------------------------------------"
      # echo "使用者後悔執行"
      echo "Function has not been executed."
      echo "---------------------------------------"
      # echo "請按 <Enter> 鍵 !!"
      echo "Press <Enter> to continue !!"
      read
      exit
   fi
}

# ------------------------------------------------------------------------

# 確認要執行函式
user_password() {
   # 確認函式
   # 確認使用者要執行命令
   #
   # echo "aa=$PST1USER"
   # echo "aa=$PST1PASS"
   # sleep 1
   op_act=$PST1USER
   # echo "請輸入使用者 $PST1USER 的密碼，確認要執行程式："
   echo "It needs the password of $PST1USER to execute:"
   stty -echo
   read op_pas
   # op_pas=op_svc123
   stty echo
   # 讀入使用者 key in 帳號的相對應密碼
   # read_pas=`echo $PST1USER | awk '{print $1}' | xargs -i grep {} $uid_file | cut -f 2 -d :`
   read_pas=$PST1PASS

   # 若該帳號存在密碼表中, 接著判斷密碼是否正確
   if [ -n "$op_pas" ] && [ $op_pas == $read_pas ]
   then
      # echo "使用者密碼正確開始執行 !!"
      echo "The password is correct !!"
   else
      # echo "密碼輸入錯誤，無法執行選擇的功能 !!"
      echo "Wrong password !!"
      # echo "....................按 <Enter> 繼續 !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      exit
   fi
}

# ------------------------------------------------------------------------

# 日期是否合理函式
con_date () {
   sys_date=`date +%Y%m%d` #系統日期(yyyymmdd)
   # 確認日期
   # 確認使用者輸入的日期格式正確(預設使用當時系統日期)
   #
   # echo "請輸入日期，\<yyyymmdd>: $sys_date"
   echo "Please input the date\<yyyymmdd>: $sys_date"
   read date

   # 判斷使用者是否有輸入
   if [ -z "$date" ]
   then
      # echo "使用者沒輸入所以預設為系統日期"
      # return_mesg="使用者沒輸入所以預設為系統日期"
      return_mesg="The default date is system date."
      date=$sys_date
      return_date1=$sys_date
      return_date=$date
      return $return_date
      return $return_mesg

      # 新功能-錯誤的話預設傳回系統日期
      return $return_date1
   fi

   # 判斷是否為八位(yyyymmdd)
   if [ `expr length $date` -ne 8 ]
   then
      # echo "日期格式不正確"
      # return_mesg="日期格式不正確"
      return_mesg="It is the wrong date format."
      return_date=1
      return_date1=$sys_date
      return $return_date
      return $return_mesg

      # 新功能-錯誤的話預設傳回系統日期
      return $return_date1
   fi

   # 判斷年份是否介於1911~2999
   year_test=`expr substr $date 1 4`
   if [ "$year_test" -lt 1911 ] || [ "$year_test" -gt 2999 ]
   then
      # echo "超出年範圍"
      # return_mesg="超出年範圍"
      return_mesg="It is out of the range of year."
      return_date=1
      return_date1=$sys_date
      return $return_date
      return $return_mesg

      # 新功能-錯誤的話預設傳回系統日期
      return $return_date1
   else
   # 判斷是否閏年
      if [ `expr $year_test % 4` -eq 0 ] && [ `expr $year_test % 100` -ne 0 ] || [ `expr $year_test % 400` -eq 0 ]
      then
         # echo "是閏年"
         bissextile=1
      else
         if [ `expr $year_test % 4` -eq 0 ] && [ `expr $year_test % 100` -eq 0 ] && [ `expr $year_test % 400` -eq 0 ]
         then
            # echo "是閏年"
            bissextile=1
         fi
         # echo "不是閏年"
         bissextile=0
      fi
   fi

   # 判斷月份是否介於1~12及判斷大小月份的天數
   month_test=`expr substr $date 5 2`
   if [ "$month_test" -lt 1 ] || [ "$month_test" -gt 12 ]
   then
      # echo "超出月範圍"
      # return_mesg="超出月範圍"
      return_mesg="It is out of the range of month."
      return_date=1
      return_date1=$sys_date
      return $return_date
      return $return_mesg

      # 新功能-錯誤的話預設傳回系統日期
      return $return_date1
   else
      if [ "$month_test" -eq 1 ] || [ "$month_test" -eq 3 ] || [ "$month_test" -eq 5 ] || [ "$month_test" -eq 7 ] || [ "$month_test" -eq 8 ] || [ "$month_test" -eq 10 ] || [ "$month_test" -eq 12 ]
      then
         # echo "大月"
         day_test=`expr substr $date 7 2`
         if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 31 ]
         then
            # echo "超出日範圍"
            # return_mesg="超出日範圍"
            return_mesg="It is out of the range of day."
            return_date=1
            return_date1=$sys_date
            return $return_date
            return $return_mesg

            # 新功能-錯誤的話預設傳回系統日期
            return $return_date1
         fi
      else
         # 判斷是否為閏年以決定二月合法天數
         if [ "$month_test" -eq 2 ] && [ "$bissextile" -eq 1 ]
         then
            # echo "閏月"
            day_test=`expr substr $date 7 2`
            if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 29 ]
            then
               # echo "超出日範圍"
               # return_mesg="超出日範圍"
               return_mesg="It is out of the range of day."
               return_date=1
               return_date1=$sys_date
               return $return_date
               return $return_mesg

               # 新功能-錯誤的話預設傳回系統日期
               return $return_date1
            fi
         else
            if [ "$month_test" -eq 2 ] && [ "$bissextile" -eq 0 ]
            then
               # echo "不是閏月"
               day_test=`expr substr $date 7 2`
               if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 28 ]
               then
                  # echo "超出日範圍"
                  # return_mesg="超出日範圍"
                  return_mesg="It is out of the range of day."
                  return_date=1
                  return_date1=$sys_date
                  return $return_date
                  return $return_mesg

                  # 新功能-錯誤的話預設傳回系統日期
                  return $return_date1
               fi
            fi
         fi

         # echo "小月"
         day_test=`expr substr $date 7 2`
         if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 30 ]
         then
            # echo "超出日範圍"
            # return_mesg="超出日範圍"
            return_mesg="It is out of the range of day."
            return_date=1
            return_date1=$sys_date
            return $return_date
            return $return_mesg

            # 新功能-錯誤的話預設傳回系統日期
            return $return_date1
         fi
      fi
   fi

   return_date=$date
   # return_mesg="日期格式正確合理"
   return_mesg="The date format is correct."
   return_date1=$sys_date

   return $return_date
   return $return_mesg

   # 新功能-錯誤的話預設傳回系統日期
   return $return_date1
}

# ------------------------------------------------------------------------

# 日期是否合理函式(後續處理)
check_date() {
   if [ $return_date != 1 ]
   # 確認日期合理, 若不合理則傳回系統日期
   then
      # echo "日期合理"
      inquire_date=$return_date
   else
      # echo "日期有誤,預設為系統日期"
      echo "It is the wrong date format, the default date is system date."
      inquire_date=$return_date1
   fi
   # echo "輸出日期 $inquire_date"
}

# ------------------------------------------------------------------------

# 是否重複執行函式
check_running() {
   check_result=0
   to_skip="vi|ps|ls|cc|cd|rm|make|xlc_r|xlC_r|oraxlc|grep|run_check"
   for pid in `ps -ef | grep $keyword | egrep -v "$to_skip" | awk '{print $0}'`
   do
      if test -n $pid
      then
         check_result=1
         echo "---------------------------------------" >> $Menu_Log_File
         # echo "程式已重複執行, 指令未執行 !!" >> $Menu_Log_File
         echo "It can not execute repeatedly in the same time !!" >> $Menu_Log_File
         echo ""
         # echo "已重複執行 !!"
         echo "Duplicate execution !!"
         # echo "請按 <Enter> 鍵 !!"
         echo "Press <Enter> to continue !!"
         read
         exit
      fi
   done
}

# 補跑回復等級函式
run_recover() {
   echo
   # echo "請選擇回復等級:"
   echo "Please choose your recovery level:"
   echo "---------------"
   # echo "(1) 全部回復"
   echo "(1) All recovery"
   # echo "(2) 錯誤回復"
   echo "(2) Error recovery"
   # echo "(3) 取消"
   echo "(3) Cancel"
   echo "---------------"
   # echo "請輸入選項號碼:(預設(2) 錯誤回復)"
   echo "Input the item number:(Default(2) Error recovery)"
   read rec_ans
   if [ -z "$rec_ans" ]
   then
      rec_ans=2
   fi
   if [ $rec_ans == 1 ]
   then
      # echo "執行全部回復"
      echo "It is performing all recovery."
      # echo "....................按 <Enter> 繼續 !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para="-Drecover=ALL"
   fi
   if [ $rec_ans == 2 ]
   then
      # echo "執行錯誤回復"
      echo "It is performing error recovery."
      # echo "....................按 <Enter> 繼續 !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para="-Drecover=ERR"
   fi
   if [ $rec_ans == 3 ]
   then
      # echo "取消"
      echo "User abandoned."
      # echo "....................按 <Enter> 繼續 !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para=""
   fi
}

# 補跑回復等級函式(只有錯誤回復選項)
run_recover_err_only() {
   echo
   # echo "請選擇回復等級:"
   echo "Please choose your recovery level:"
   echo "---------------"
   # echo "(1) 錯誤回復"
   echo "(1) Error recovery"
   # echo "(2) 取消"
   echo "(2) Cancel"
   echo "---------------"
   # echo "請輸入選項號碼:(預設(1) 錯誤回復)"
   echo "Input the item number:(Default(1) Error recovery)"
   read rec_ans
   if [ -z "$rec_ans" ]
   then
      rec_ans=1
   fi
   if [ $rec_ans == 1 ]
   then
      # echo "執行錯誤回復"
      echo "It is performing error recovery."
      # echo "....................按 <Enter> 繼續 !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para="-Drecover=ERR"
   fi
   if [ $rec_ans == 2 ]
   then
      # echo "取消"
      echo "User abandoned."
      # echo "....................按 <Enter> 繼續 !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para=""
   fi
}

# 使用者輸入原始 Table 名稱函式
original_table_name() {
   echo
   # echo "請輸入原始 Table 名稱(TB_XXX):"
   echo "Please input the original table name(TB_XXX):"
   read table_ans
}

# ------------------------------------------------------------------------
# 紀錄函式群
# ------------------------------------------------------------------------

# 紀錄程式開始時間函式
start_time() {
   moment=`date +%Y/%m/%d`,`date +%T`
   echo "---------------------------------------"
   echo "---------------------------------------" >> $Menu_Log_File
   # echo "程式執行時間 $moment"
   echo "Start time $moment"
   # echo "程式執行時間 $moment" >> $Menu_Log_File
   echo "Start time $moment" >> $Menu_Log_File
}

# 紀錄程式結束時間函式
finish_time() {
   moment=`date +%Y/%m/%d`,`date +%T`
   echo "---------------------------------------"
   echo "---------------------------------------" >> $Menu_Log_File
   # echo "程式完成時間 $moment"
   echo "Finish time $moment"
   # echo "程式完成時間 $moment" >> $Menu_Log_File
   echo "Finish time $moment" >> $Menu_Log_File
}

# 紀錄執行程式身分函式
change_user() {
   # echo "執行程式身分 $usr_name"
   echo "Perform function ID $usr_name"
   # echo "執行程式身分 $usr_name" >> $Menu_Log_File
   echo "Perform function ID $usr_name" >> $Menu_Log_File
}

# 紀錄執行程式名稱函式
program_name() {
   # echo "執行程式名稱 $pro_name"
   echo "Perform function name $pro_name"
   # echo "執行程式名稱 $pro_name" >> $Menu_Log_File
   echo "Perform function name $pro_name" >> $Menu_Log_File
}

# 紀錄日期參數函式
date_parameter() {
   # echo "執行日期參數: $need_date"
   echo "Perform date parameter: $need_date"
   # echo "執行日期參數: $need_date" >> $Menu_Log_File
   echo "Perform date parameter: $need_date" >> $Menu_Log_File
}

# ------------------------------------------------------------------------

# 將執行程式名稱及執行身分參數另外帶入供紀錄函式群使用
pro_name=$4
usr_name=$6

# 判斷讀入的各個參數值, 決定執行條件
if [ $2 == 1 ]
then
   # echo "需要輸入日期參數"
   con_date
   check_date
   need_date=$inquire_date
else
   # echo "不需輸入日期參數"
   need_date=""
fi

if [ $1 == 1 ]
then
   # echo "需要詢問是否確認執行"
   confirm
fi

# 以使用者密碼確認執行
if [ $1 == 2 ]
then
   # echo "詢問是否確認執行,以使用者密碼"
   user_password
fi

if [ $3 == 1 ]
then
   # echo "需要確認沒有重複執行"
   check_running
fi

if [ -z "$6" ]
then
   start_time
   program_name
   if [ -n "$need_date" ]
   then
      date_parameter
   fi
   $exec_path/$4 $need_date
else
   if [ "$6" = "go7" ]
   then
      echo "---------------------------------------"
   else
      # echo "變更使用者: $6, 方執行該項功能"
      echo "Change account $6 to execte this function."
      start_time
      echo -n "Password: "
      su - $6 -c "$exec_path/$4 $need_date" 2> /dev/null

      if [ $? != 0 ]
      then
         echo
         echo "---------------------------------------"
         echo "---------------------------------------" >> $Menu_Log_File
         # echo "切換執行身分失敗 !!"
         echo "Change account failed !!"
         # echo "切換執行身分失敗 !!" >> $Menu_Log_File
         echo "Change account failed !!" >> $Menu_Log_File
      fi
      echo
      change_user
      program_name
      if [ -n "$need_date" ]
      then
         date_parameter
      fi
   fi
fi

if [ -n "$7" ]
then
   if [ $7 == 1 ]
   then
      start_time
      program_name
      if [ -n "$need_date" ]
      then
         date_parameter
      fi
      run_recover
      if [ "$recover_para" = "" ]
      then
         # echo "不跑回復"
         echo "Does not perform recovery."
      else
         # echo "跑回復"
         echo "Perform recovery."
         echo "$exec_path/$4 $need_date $recover_para"
         $exec_path/$4 $need_date $recover_para
      fi
   fi

   if [ $7 == 2 ]
   then
      start_time
      program_name
      if [ -n "$need_date" ]
      then
         date_parameter
      fi
      run_recover_err_only
      if [ "$recover_para" = "" ]
      then
         # echo "不跑回復"
         echo "Does not perform recovery."
      else
         # echo "跑回復"
         echo "Perform recovery."
         echo "$exec_path/$4 $need_date $recover_para"
         $exec_path/$4 $need_date $recover_para
      fi
   fi

   if [ $7 == 3 ]
   then
      start_time
      program_name
      if [ -n "$need_date" ]
      then
         date_parameter
      fi
      original_table_name
      if [ "$table_ans" = "" ]
      then
         # echo "未輸入 Table 名稱"
         echo "You has not input the table name."
      else
         if [ "$need_date" = "" ]
         then
            need_date="no_need"
         fi
         # echo "Table 名稱: $table_ans"
         echo "Table name: $table_ans"
         echo "$exec_path/$4 $need_date $table_ans"
         $exec_path/$4 $need_date $table_ans
      fi
   fi
fi

finish_time

echo
# echo "請按 <Enter> 鍵 !!"
echo "Press <Enter> to continue !!"
trap "" 2 3

read

