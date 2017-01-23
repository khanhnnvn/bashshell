#!/bin/bash

# 環境設定檔

# 環境相關設定 ------------------------------------------------
# 設定環境路徑
# PATH=/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:/usr/ucb:.
# export PATH

# 程式目錄相關設定 --------------------------------------------
# 設定 op_menu 的根目錄的路徑
#opmenu_root_path=${HOME}/op_svc
opmenu_root_path=${HOME}

# 設定 exec 目錄的路徑
exec_path=${opmenu_root_path}/execsh
export exec_path

# 設定 op_menu 目錄的路徑
op_menu_path=${exec_path}/op_menu

# 設定 sh 檔案存放目錄的路徑
Sh_Dir=${op_menu_path}
export Sh_Dir

# 群組/使用者 帳號/密碼 檔案相關設定 --------------------------------------------
# 指定使用者設定檔
gid_file=${op_menu_path}/.gid.dat
uid_file=${op_menu_path}/.uid.dat
export gid_file
export uid_file

# 程式目錄相關設定 --------------------------------------------
# 指定群組使用的選單設定檔
group1=${op_menu_path}/group1_menu.conf
group2=${op_menu_path}/group2_menu.conf
group3=${op_menu_path}/group3_menu.conf
export group1
export group2
export group3

# op_menu 選單環境相關設定 --------------------------------------------
# 設定主選單標題
menu_title=VNPT_EPAY
export menu_title

# 讀取主機名稱
#host_name=`hostname`
#export host_name

# 讀取登入使用者名稱
run_date=`date +%Y/%m/%d`,`date +%T`
run_user=`whoami`
login_user=`who am i`
login_id=`who am i | awk '{print $1}'`
export run_date
export run_user
export login_user
export login_id

# 依照 username 及 pts 定義 temp log name
user_part1=`who am i | awk '{print $1}'`
user_part2=`who am i | awk '{print $2}' | sed -e 's/\///'`
user_full=${user_part1}_${user_part2}
export user_full

# Temp 目錄相關設定 -------------------------------------------
# 設定程式 temp 的目錄路徑
temp_path=/tmp/`who am i | awk {'print $1'}`_op_menu
export temp_path
# Log 目錄相關設定 ---------------------------------------------

# 設定時間來命名 log 檔名
log_date=`date +%Y%m%d`

# 設定程式 log 的目錄路徑
save_dir=${opmenu_root_path}/log/opmenu_log
#export save_dir

# 設定 log 開頭檔案名稱
Menu_Log_Dir=${save_dir}/opmenu

# 設定選項暫存檔名稱
status1_file=${temp_path}/${user_full}_menu-status1.dat
export status1_file

# 設定執行命令暫存檔名稱
browfile=${temp_path}/${user_full}_menu-run-file
export browfile

# 設定 log 暫存檔名稱
Log_Temp_File=${temp_path}/${user_full}_menu-temp.log
export Log_Temp_File

# 設定 log 檔案名稱
Menu_Log_File=${Menu_Log_Dir}_${log_date}.log
#Menu_Log_File=`sed '/#/d' $list_file | awk -F= '/Menu_Log_File=/{print $2}'`_"$log_date".log;
export Menu_Log_File

