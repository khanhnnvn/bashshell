#!/usr/bin/bash

# �T��ϥΪ̥H Ctrl-? ������

# ���Ҭ����]�w --------------------------------------------------------

# ���ҳ]�w��

# �{���ؿ������]�w ----------------------------------------------------

# Ū������D�{�����ؿ����|

. $HOME/execsh/op_menu/set_menu.sh

# Temp �ؿ������]�w ---------------------------------------------------

# Ū���{�� temp ���ؿ����|

# �P�_ temp_path �O�_�s�b, �Y���s�b, �إߤ�
if [ ! -d $temp_path ]
then
   mkdir -p $temp_path
fi

# �̷� username �� pts �w�q temp log name
# user_part1=`who am i | awk '{print $1}'`
# user_part2=`who am i | awk '{print $2}' | sed -e 's/\///'`
# user_full=${user_part1}_${user_part2}

# �]�w log �Ȧs�ɦW��
# Log_Temp_File=${temp_path}/${user_full}_menu-temp.log

# Log �ؿ������]�w ----------------------------------------------------

# �]�w�ɶ��өR�W log �ɦW
# log_date=`date +%Y%m%d`

# Ū���{�� log ���ؿ����|

# Ū�� log �ɮצW��

# ---------------------------------------------------------------------

# �ܧ�����{�����D�ؿ�
cd $exec_path

# ���ϥΪ̪��D�ثe�����涵��
cat $Log_Temp_File
echo

# ��ܥ� op menu �a�i�Ӫ��Ѽƭ�
# echo
# echo "$1 $2 $3 $4 $5 $6"

# all = �Ҧ��Ѽ�(�ˬd�O�_���ư����)
# all="$1|$2|$3|$4|$5|$6"
# keyword = �n�ˬd�O�_���ƪ�����r
keyword=$5

# ------------------------------------------------------------------------

# �T�{�n����禡
confirm() {
   # �T�{�禡
   # �T�{�ϥΪ̭n����R�O
   #
   # echo "�T�{�n����{��? (Yy/Nn): "
   echo "Are you sure to execute? (Yy/Nn): "
   read tans
   if [ -n "$tans" ] && [ $tans = "y" -o $tans = "Y" ]
   then
      # clear
      # echo "�T�{����!"
      echo ""
   else
      # clear
      # echo "�ᮬ����!"
      echo "---------------------------------------" >> $Menu_Log_File
      # echo "�ϥΪ̫ᮬ����, ���O������ !!" >> $Menu_Log_File
      echo "User abandoned !!" >> $Menu_Log_File
      echo "---------------------------------------"
      # echo "�ϥΪ̫ᮬ����"
      echo "Function has not been executed."
      echo "---------------------------------------"
      # echo "�Ы� <Enter> �� !!"
      echo "Press <Enter> to continue !!"
      read
      exit
   fi
}

# ------------------------------------------------------------------------

# �T�{�n����禡
user_password() {
   # �T�{�禡
   # �T�{�ϥΪ̭n����R�O
   #
   # echo "aa=$PST1USER"
   # echo "aa=$PST1PASS"
   # sleep 1
   op_act=$PST1USER
   # echo "�п�J�ϥΪ� $PST1USER ���K�X�A�T�{�n����{���G"
   echo "It needs the password of $PST1USER to execute:"
   stty -echo
   read op_pas
   # op_pas=op_svc123
   stty echo
   # Ū�J�ϥΪ� key in �b�����۹����K�X
   # read_pas=`echo $PST1USER | awk '{print $1}' | xargs -i grep {} $uid_file | cut -f 2 -d :`
   read_pas=$PST1PASS

   # �Y�ӱb���s�b�K�X��, ���ۧP�_�K�X�O�_���T
   if [ -n "$op_pas" ] && [ $op_pas == $read_pas ]
   then
      # echo "�ϥΪ̱K�X���T�}�l���� !!"
      echo "The password is correct !!"
   else
      # echo "�K�X��J���~�A�L�k�����ܪ��\�� !!"
      echo "Wrong password !!"
      # echo "....................�� <Enter> �~�� !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      exit
   fi
}

# ------------------------------------------------------------------------

# ����O�_�X�z�禡
con_date () {
   sys_date=`date +%Y%m%d` #�t�Τ��(yyyymmdd)
   # �T�{���
   # �T�{�ϥΪ̿�J������榡���T(�w�]�ϥη�ɨt�Τ��)
   #
   # echo "�п�J����A\<yyyymmdd>: $sys_date"
   echo "Please input the date\<yyyymmdd>: $sys_date"
   read date

   # �P�_�ϥΪ̬O�_����J
   if [ -z "$date" ]
   then
      # echo "�ϥΪ̨S��J�ҥH�w�]���t�Τ��"
      # return_mesg="�ϥΪ̨S��J�ҥH�w�]���t�Τ��"
      return_mesg="The default date is system date."
      date=$sys_date
      return_date1=$sys_date
      return_date=$date
      return $return_date
      return $return_mesg

      # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
      return $return_date1
   fi

   # �P�_�O�_���K��(yyyymmdd)
   if [ `expr length $date` -ne 8 ]
   then
      # echo "����榡�����T"
      # return_mesg="����榡�����T"
      return_mesg="It is the wrong date format."
      return_date=1
      return_date1=$sys_date
      return $return_date
      return $return_mesg

      # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
      return $return_date1
   fi

   # �P�_�~���O�_����1911~2999
   year_test=`expr substr $date 1 4`
   if [ "$year_test" -lt 1911 ] || [ "$year_test" -gt 2999 ]
   then
      # echo "�W�X�~�d��"
      # return_mesg="�W�X�~�d��"
      return_mesg="It is out of the range of year."
      return_date=1
      return_date1=$sys_date
      return $return_date
      return $return_mesg

      # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
      return $return_date1
   else
   # �P�_�O�_�|�~
      if [ `expr $year_test % 4` -eq 0 ] && [ `expr $year_test % 100` -ne 0 ] || [ `expr $year_test % 400` -eq 0 ]
      then
         # echo "�O�|�~"
         bissextile=1
      else
         if [ `expr $year_test % 4` -eq 0 ] && [ `expr $year_test % 100` -eq 0 ] && [ `expr $year_test % 400` -eq 0 ]
         then
            # echo "�O�|�~"
            bissextile=1
         fi
         # echo "���O�|�~"
         bissextile=0
      fi
   fi

   # �P�_����O�_����1~12�ΧP�_�j�p������Ѽ�
   month_test=`expr substr $date 5 2`
   if [ "$month_test" -lt 1 ] || [ "$month_test" -gt 12 ]
   then
      # echo "�W�X��d��"
      # return_mesg="�W�X��d��"
      return_mesg="It is out of the range of month."
      return_date=1
      return_date1=$sys_date
      return $return_date
      return $return_mesg

      # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
      return $return_date1
   else
      if [ "$month_test" -eq 1 ] || [ "$month_test" -eq 3 ] || [ "$month_test" -eq 5 ] || [ "$month_test" -eq 7 ] || [ "$month_test" -eq 8 ] || [ "$month_test" -eq 10 ] || [ "$month_test" -eq 12 ]
      then
         # echo "�j��"
         day_test=`expr substr $date 7 2`
         if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 31 ]
         then
            # echo "�W�X��d��"
            # return_mesg="�W�X��d��"
            return_mesg="It is out of the range of day."
            return_date=1
            return_date1=$sys_date
            return $return_date
            return $return_mesg

            # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
            return $return_date1
         fi
      else
         # �P�_�O�_���|�~�H�M�w�G��X�k�Ѽ�
         if [ "$month_test" -eq 2 ] && [ "$bissextile" -eq 1 ]
         then
            # echo "�|��"
            day_test=`expr substr $date 7 2`
            if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 29 ]
            then
               # echo "�W�X��d��"
               # return_mesg="�W�X��d��"
               return_mesg="It is out of the range of day."
               return_date=1
               return_date1=$sys_date
               return $return_date
               return $return_mesg

               # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
               return $return_date1
            fi
         else
            if [ "$month_test" -eq 2 ] && [ "$bissextile" -eq 0 ]
            then
               # echo "���O�|��"
               day_test=`expr substr $date 7 2`
               if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 28 ]
               then
                  # echo "�W�X��d��"
                  # return_mesg="�W�X��d��"
                  return_mesg="It is out of the range of day."
                  return_date=1
                  return_date1=$sys_date
                  return $return_date
                  return $return_mesg

                  # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
                  return $return_date1
               fi
            fi
         fi

         # echo "�p��"
         day_test=`expr substr $date 7 2`
         if [ "$day_test" -lt 1 ] || [ "$day_test" -gt 30 ]
         then
            # echo "�W�X��d��"
            # return_mesg="�W�X��d��"
            return_mesg="It is out of the range of day."
            return_date=1
            return_date1=$sys_date
            return $return_date
            return $return_mesg

            # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
            return $return_date1
         fi
      fi
   fi

   return_date=$date
   # return_mesg="����榡���T�X�z"
   return_mesg="The date format is correct."
   return_date1=$sys_date

   return $return_date
   return $return_mesg

   # �s�\��-���~���ܹw�]�Ǧ^�t�Τ��
   return $return_date1
}

# ------------------------------------------------------------------------

# ����O�_�X�z�禡(����B�z)
check_date() {
   if [ $return_date != 1 ]
   # �T�{����X�z, �Y���X�z�h�Ǧ^�t�Τ��
   then
      # echo "����X�z"
      inquire_date=$return_date
   else
      # echo "������~,�w�]���t�Τ��"
      echo "It is the wrong date format, the default date is system date."
      inquire_date=$return_date1
   fi
   # echo "��X��� $inquire_date"
}

# ------------------------------------------------------------------------

# �O�_���ư���禡
check_running() {
   check_result=0
   to_skip="vi|ps|ls|cc|cd|rm|make|xlc_r|xlC_r|oraxlc|grep|run_check"
   for pid in `ps -ef | grep $keyword | egrep -v "$to_skip" | awk '{print $0}'`
   do
      if test -n $pid
      then
         check_result=1
         echo "---------------------------------------" >> $Menu_Log_File
         # echo "�{���w���ư���, ���O������ !!" >> $Menu_Log_File
         echo "It can not execute repeatedly in the same time !!" >> $Menu_Log_File
         echo ""
         # echo "�w���ư��� !!"
         echo "Duplicate execution !!"
         # echo "�Ы� <Enter> �� !!"
         echo "Press <Enter> to continue !!"
         read
         exit
      fi
   done
}

# �ɶ]�^�_���Ũ禡
run_recover() {
   echo
   # echo "�п�ܦ^�_����:"
   echo "Please choose your recovery level:"
   echo "---------------"
   # echo "(1) �����^�_"
   echo "(1) All recovery"
   # echo "(2) ���~�^�_"
   echo "(2) Error recovery"
   # echo "(3) ����"
   echo "(3) Cancel"
   echo "---------------"
   # echo "�п�J�ﶵ���X:(�w�](2) ���~�^�_)"
   echo "Input the item number:(Default(2) Error recovery)"
   read rec_ans
   if [ -z "$rec_ans" ]
   then
      rec_ans=2
   fi
   if [ $rec_ans == 1 ]
   then
      # echo "��������^�_"
      echo "It is performing all recovery."
      # echo "....................�� <Enter> �~�� !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para="-Drecover=ALL"
   fi
   if [ $rec_ans == 2 ]
   then
      # echo "������~�^�_"
      echo "It is performing error recovery."
      # echo "....................�� <Enter> �~�� !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para="-Drecover=ERR"
   fi
   if [ $rec_ans == 3 ]
   then
      # echo "����"
      echo "User abandoned."
      # echo "....................�� <Enter> �~�� !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para=""
   fi
}

# �ɶ]�^�_���Ũ禡(�u�����~�^�_�ﶵ)
run_recover_err_only() {
   echo
   # echo "�п�ܦ^�_����:"
   echo "Please choose your recovery level:"
   echo "---------------"
   # echo "(1) ���~�^�_"
   echo "(1) Error recovery"
   # echo "(2) ����"
   echo "(2) Cancel"
   echo "---------------"
   # echo "�п�J�ﶵ���X:(�w�](1) ���~�^�_)"
   echo "Input the item number:(Default(1) Error recovery)"
   read rec_ans
   if [ -z "$rec_ans" ]
   then
      rec_ans=1
   fi
   if [ $rec_ans == 1 ]
   then
      # echo "������~�^�_"
      echo "It is performing error recovery."
      # echo "....................�� <Enter> �~�� !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para="-Drecover=ERR"
   fi
   if [ $rec_ans == 2 ]
   then
      # echo "����"
      echo "User abandoned."
      # echo "....................�� <Enter> �~�� !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      recover_para=""
   fi
}

# �ϥΪ̿�J��l Table �W�٨禡
original_table_name() {
   echo
   # echo "�п�J��l Table �W��(TB_XXX):"
   echo "Please input the original table name(TB_XXX):"
   read table_ans
}

# ------------------------------------------------------------------------
# �����禡�s
# ------------------------------------------------------------------------

# �����{���}�l�ɶ��禡
start_time() {
   moment=`date +%Y/%m/%d`,`date +%T`
   echo "---------------------------------------"
   echo "---------------------------------------" >> $Menu_Log_File
   # echo "�{������ɶ� $moment"
   echo "Start time $moment"
   # echo "�{������ɶ� $moment" >> $Menu_Log_File
   echo "Start time $moment" >> $Menu_Log_File
}

# �����{�������ɶ��禡
finish_time() {
   moment=`date +%Y/%m/%d`,`date +%T`
   echo "---------------------------------------"
   echo "---------------------------------------" >> $Menu_Log_File
   # echo "�{�������ɶ� $moment"
   echo "Finish time $moment"
   # echo "�{�������ɶ� $moment" >> $Menu_Log_File
   echo "Finish time $moment" >> $Menu_Log_File
}

# ��������{�������禡
change_user() {
   # echo "����{������ $usr_name"
   echo "Perform function ID $usr_name"
   # echo "����{������ $usr_name" >> $Menu_Log_File
   echo "Perform function ID $usr_name" >> $Menu_Log_File
}

# ��������{���W�٨禡
program_name() {
   # echo "����{���W�� $pro_name"
   echo "Perform function name $pro_name"
   # echo "����{���W�� $pro_name" >> $Menu_Log_File
   echo "Perform function name $pro_name" >> $Menu_Log_File
}

# ��������Ѽƨ禡
date_parameter() {
   # echo "�������Ѽ�: $need_date"
   echo "Perform date parameter: $need_date"
   # echo "�������Ѽ�: $need_date" >> $Menu_Log_File
   echo "Perform date parameter: $need_date" >> $Menu_Log_File
}

# ------------------------------------------------------------------------

# �N����{���W�٤ΰ��樭���Ѽƥt�~�a�J�Ѭ����禡�s�ϥ�
pro_name=$4
usr_name=$6

# �P�_Ū�J���U�ӰѼƭ�, �M�w�������
if [ $2 == 1 ]
then
   # echo "�ݭn��J����Ѽ�"
   con_date
   check_date
   need_date=$inquire_date
else
   # echo "���ݿ�J����Ѽ�"
   need_date=""
fi

if [ $1 == 1 ]
then
   # echo "�ݭn�߰ݬO�_�T�{����"
   confirm
fi

# �H�ϥΪ̱K�X�T�{����
if [ $1 == 2 ]
then
   # echo "�߰ݬO�_�T�{����,�H�ϥΪ̱K�X"
   user_password
fi

if [ $3 == 1 ]
then
   # echo "�ݭn�T�{�S�����ư���"
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
      # echo "�ܧ�ϥΪ�: $6, �����Ӷ��\��"
      echo "Change account $6 to execte this function."
      start_time
      echo -n "Password: "
      su - $6 -c "$exec_path/$4 $need_date" 2> /dev/null

      if [ $? != 0 ]
      then
         echo
         echo "---------------------------------------"
         echo "---------------------------------------" >> $Menu_Log_File
         # echo "�������樭������ !!"
         echo "Change account failed !!"
         # echo "�������樭������ !!" >> $Menu_Log_File
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
         # echo "���]�^�_"
         echo "Does not perform recovery."
      else
         # echo "�]�^�_"
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
         # echo "���]�^�_"
         echo "Does not perform recovery."
      else
         # echo "�]�^�_"
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
         # echo "����J Table �W��"
         echo "You has not input the table name."
      else
         if [ "$need_date" = "" ]
         then
            need_date="no_need"
         fi
         # echo "Table �W��: $table_ans"
         echo "Table name: $table_ans"
         echo "$exec_path/$4 $need_date $table_ans"
         $exec_path/$4 $need_date $table_ans
      fi
   fi
fi

finish_time

echo
# echo "�Ы� <Enter> �� !!"
echo "Press <Enter> to continue !!"
trap "" 2 3

read

