#!/bin/bash

# �T��ϥΪ̥H Ctrl-? ������
trap "" 2 3

# ���Ҭ����]�w --------------------------------------------------------

# ���w���ҳ]�w��
. $HOME/execsh/op_menu/set_menu.sh

# Ū���ϥΪ̵n�J�b���αK�X --------------------------------------------

# echo "�п�J OP_MENU �ϥαb��: "
echo "OP menu login account: "
# read op_act
op_act=vnpt_op

# echo "�п�J $op_act �K�X: "
echo "$op_act password: "
stty -echo
# read op_pas
op_pas=vnpt_op123
stty echo
# sleep 3
# echo "a=$op_pas"
# echo "b=$uid_file"

# �T�{�ӱb���O�_�s�b --------------------------------------------------

# Ū�J�ϥΪ� key in ���b���çP�_�O�_���K�X��
op_act_a=$op_act:
# echo $op_acta
read_act=`echo $op_act_a | awk '{print $1}' | xargs -i grep {} $uid_file | cut -f 1 -d :`

# �Y�ӱb�����s�b�K�X���h���}
if [ -z $read_act ]
then
   # echo "�b�����~�A�A�S���v������ !!"
   echo "Wrong account !!"
   # echo "....................�� <Enter> �~�� !!...................."
   echo "....................Press <Enter> to continue !!...................."
   read
   exit
fi

# Ū�J�ϥΪ� key in �b�����۹����K�X
read_pas=`echo $op_act_a | awk '{print $1}' | xargs -i grep {} $uid_file | cut -f 2 -d :`

# �Y�ӱb���s�b�K�X��, ���ۧP�_�K�X�O�_���T
if [ $op_pas != $read_pas ]
then
   # echo "�K�X���~�A�A�S���v������ !!"
   echo "Wrong password !!"
   # echo "....................�� <Enter> �~�� !!...................."
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

   # Ū���D���]�w���ɦW
   # Ū�J�ܼ�, �ýT�{�O�_�s�b��۩w�s�դ�
   check_group=`echo $read_act | awk '{print $1}' | xargs -i grep {} $gid_file | cut -f 1 -d :`
   if [ -z $check_group ]
   then
      # echo "�A���ݩ�i����s�� !!"
      echo "You are not a member of executing group !!"
      # echo "....................�� <Enter> �~�� !!...................."
      echo "....................Press <Enter> to continue !!...................."
      read
      exit
   else
      # �q�X�ϥΪ̩��ݪ��۩w�s�զW
      # echo "�A���ݪ��s��: $check_group"
      # echo "....................�� <Enter> �~��!!...................."
      # read

      # �̷Ӹs�զW�w�q���]�w��
      # aa=$(eval echo \$$check_group)
      menu_file=$(eval echo \$$check_group)
      export menu_file
      # echo "menu_file �����e��: $menu_file"
      # echo "....................�� <Enter> �~��!!...................."
      # read
   fi
fi

# �{���ؿ������]�w ----------------------------------------------------

# �P�_ temp_path �O�_�s�b, �Y���s�b, �إߤ�
if [ ! -d $temp_path ]
then
   mkdir -p $temp_path
fi

# ---------------------------------------------------------------------

# �ܧ�� op_menu  sh �{���ؿ�
cd $Sh_Dir

# �ˬd�ﶵ�Ȧs��,�Y���s�b�h�إߨó]�w��l�Ȭ�1
if [ ! -f $status1_file ]
then
   echo "1" > $status1_file
fi

# menu.conf �ɮ׮榡����
# ���W��|�ﶵ�s��|��|�C|����|./run_check.sh %1 %2 %3 %4 %5 %6
# %1 �T�{�n����\�઺�Ѽ�
# %2 �T�{������X�z���Ѽ�
# %3 �ˬd�O�_���ư��檺�Ѽ�
# %4 ���w�I�s�� shell ����|+�ɦW
# %5 �t�X %3 �ˬd�O�_���ư��檺 "keyword"
# %6 �O�_�� su ����L user ����(�ثe���\��L��)
# �d��: main|21|12|0|��ܥثe�t�ΪŶ�|./run_check.sh 1  1  1  ./op_menu/ChkHDSpace1.sh ChkHDSpace1.sh root
#                                                    %1 %2 %3            %4                  %5        %6
# �䤤: %1 , %2 , %3 = 1 ���u, = 0 ����, ���U�ӥ\�ඵ�جO�_�n�ϥΦөw
# ----------------------------------------------------------------------
# �Y�ﶵ�s����0�h����ܻ���,�Фſ�J���檺�R�O
# �D���W�٬� main , ��l�����ۭq,�]�w�����d�Ҧp�U
# ���W��|�ﶵ�s��|��|�C|����|menu �����W�� 0 ����满�� �w��s��
# main|2|12|10|������w�ؿ��U��a.sh|./run_check.sh 1 1 1 ./op_menu_new/a.sh a.sh root
# main|0|10|14|�d�ݤ��|
# main|5|13|10|�妸���|menu batch 0 �妸��� 1
# batch|1|11|10|�s����|vi test
# batch|1|11|10|�s����|vi test1
# ----------------------------------------------------------------------

menu()
{
   # sleep 5
   rm -f $browfile 1>/dev/null 2>&1
   clear

   # �p�G����ﶵ 2, 33, 63, �h�Ȯɥi�ϥ� Ctrl+C �����@�~
   if [ $2 == 43 ]
   then
      trap 2
   else
      trap "" 2
   fi

   [ $2 = "q" ] && return
   echo `
   awk ' BEGIN {
      FS = "|"      # ��J�� menu main 0 "�����޿��"
      if ( "'$2'" == "0" )      # $2 ��0
         printf("-en \033[2;26H\033[4m%s\033[0m","'$3'")      # $3 �� �����޿��
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
         # printf( "\033[23;5H %s �п�ܭn���檺���� , ��J q �h�h�X: ","'$4'" )
         printf( "\033[25;5H %s Choose your option, or <q> to quit: ","'$4'" )
   } ' "$menu_file"
   `
   [ -f $browfile ] &&
   {

      echo "" >> $Menu_Log_File
      echo "=======================================" >> $Menu_Log_File
      # echo "����ɶ� $run_date" >> $Menu_Log_File
      echo "Executing date $run_date" >> $Menu_Log_File
      # echo "����ﶵ `cat $Log_Temp_File` " >> $Menu_Log_File
      echo "Executing item `cat $Log_Temp_File` " >> $Menu_Log_File
      # echo "����R�O `cat $browfile` " >> $Menu_Log_File
      echo "Executing command `cat $browfile` " >> $Menu_Log_File
      # echo "����H���b�� $run_user " >> $Menu_Log_File
      echo "Executing member account $run_user " >> $Menu_Log_File
      # echo "�n�J�H���b�� $login_user " >> $Menu_Log_File
      echo "Login member account $login_user " >> $Menu_Log_File
      # echo "OP MENU �b�� $PST1USER " >> $Menu_Log_File
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
      # echo "����^���X -$err- " >> $Menu_Log_File
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
         # echo "=======================�t�Ϊ��A����========================="
         echo "=======================System Status========================="
         # echo "��檺���榳���D, ������Ʀp�U"
         echo "failed execution, the information as below"
         # echo "���檺��涵��"
         echo "Executing item"
         cat $Log_Temp_File
         echo ""
         # echo "���檺�R�O���e"
         echo "Executing command"
         cat $browfile
         echo ""
         # echo "�^���X -$err-"
         echo "Response code -$err-"
         rm -f $browfile 1>/dev/null 2>&1
         # echo "....................�����N���~�� !!.........................."
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

# menu main 0 "--$menu_title--(�D��:$HOSTNAME)" "(�n�J�b��:$op_act,�s��:$check_group)" 1
menu main 0 "--$menu_title--(Hostname:$HOSTNAME)" "(Account:$op_act,Group:$check_group)" 1

# �p�G UID �� OP �b��, �h�D���� "q" �H�᪽���n�X
if [ "$login_id" = "$run_user" ] && [ -z $USER_EXIT ]
then
   # echo "USER_EXIT=$USER_EXIT="
   # sleep 3
   # ps | grep sh | grep -v grep | awk '{print $1}' | xargs -i kill -9 {} > /dev/null 2>&1
   cd
fi

