#!/bin/bash

# ���ҳ]�w��

# ���Ҭ����]�w ------------------------------------------------
# �]�w���Ҹ��|
# PATH=/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:/usr/ucb:.
# export PATH

# �{���ؿ������]�w --------------------------------------------
# �]�w op_menu ���ڥؿ������|
#opmenu_root_path=${HOME}/op_svc
opmenu_root_path=${HOME}

# �]�w exec �ؿ������|
exec_path=${opmenu_root_path}/execsh
export exec_path

# �]�w op_menu �ؿ������|
op_menu_path=${exec_path}/op_menu

# �]�w sh �ɮצs��ؿ������|
Sh_Dir=${op_menu_path}
export Sh_Dir

# �s��/�ϥΪ� �b��/�K�X �ɮ׬����]�w --------------------------------------------
# ���w�ϥΪ̳]�w��
gid_file=${op_menu_path}/.gid.dat
uid_file=${op_menu_path}/.uid.dat
export gid_file
export uid_file

# �{���ؿ������]�w --------------------------------------------
# ���w�s�ըϥΪ����]�w��
group1=${op_menu_path}/group1_menu.conf
group2=${op_menu_path}/group2_menu.conf
group3=${op_menu_path}/group3_menu.conf
export group1
export group2
export group3

# op_menu ������Ҭ����]�w --------------------------------------------
# �]�w�D�����D
menu_title=VNPT_EPAY
export menu_title

# Ū���D���W��
#host_name=`hostname`
#export host_name

# Ū���n�J�ϥΪ̦W��
run_date=`date +%Y/%m/%d`,`date +%T`
run_user=`whoami`
login_user=`who am i`
login_id=`who am i | awk '{print $1}'`
export run_date
export run_user
export login_user
export login_id

# �̷� username �� pts �w�q temp log name
user_part1=`who am i | awk '{print $1}'`
user_part2=`who am i | awk '{print $2}' | sed -e 's/\///'`
user_full=${user_part1}_${user_part2}
export user_full

# Temp �ؿ������]�w -------------------------------------------
# �]�w�{�� temp ���ؿ����|
temp_path=/tmp/`who am i | awk {'print $1'}`_op_menu
export temp_path
# Log �ؿ������]�w ---------------------------------------------

# �]�w�ɶ��өR�W log �ɦW
log_date=`date +%Y%m%d`

# �]�w�{�� log ���ؿ����|
save_dir=${opmenu_root_path}/log/opmenu_log
#export save_dir

# �]�w log �}�Y�ɮצW��
Menu_Log_Dir=${save_dir}/opmenu

# �]�w�ﶵ�Ȧs�ɦW��
status1_file=${temp_path}/${user_full}_menu-status1.dat
export status1_file

# �]�w����R�O�Ȧs�ɦW��
browfile=${temp_path}/${user_full}_menu-run-file
export browfile

# �]�w log �Ȧs�ɦW��
Log_Temp_File=${temp_path}/${user_full}_menu-temp.log
export Log_Temp_File

# �]�w log �ɮצW��
Menu_Log_File=${Menu_Log_Dir}_${log_date}.log
#Menu_Log_File=`sed '/#/d' $list_file | awk -F= '/Menu_Log_File=/{print $2}'`_"$log_date".log;
export Menu_Log_File

