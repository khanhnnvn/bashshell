#!/bin/ksh

trap "" 2 3

CUR_DATE=`date '+%Y/%m/%d'`
CUR_TIME=`date '+%T'`

### set -o ignoreeof

echo "####################### View $CUR_DATE $CUR_TIME #########################"
df -k | grep -v proc | grep -v fd | grep -v mnttab | grep -v swap
echo "##########################################################################"

df -k | grep -v proc | grep -v fd | grep -v mnttab | grep -v swap | grep -v Filesystem | nawk '
BEGIN { x=0 }
{
   if ($5 ~ /^[8-9][0-9][\%]/) {print "\n\033[41m\aFile system usage " $6 " exceed 80%\033[40;0m"; x=x+1 ;}
   if ($5 ~ /^[1][0][0][\%]/) {print "\n\033[41m\aFile system usage " $6 " are 100%\033[40;0m"; x=x+1 ;}
}
END {
   if (x>0)
      {printf "\n\033[41m\033[5mWARNING!!\033[0m\a\033[41m --> Please notify System Administrator !!\033[40;0m\033[39m\n\n";}
   else
      {printf "\n All file system usage are normal. \n\n ";}
}'

