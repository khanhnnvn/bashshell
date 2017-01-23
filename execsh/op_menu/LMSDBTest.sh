#!/bin/ksh

LOG_FILE="$SYSOP_LOG_DIR/DB_Test_`date '+%Y%m%d'`.log"
ORAID=$ORACLE_SID
ORAUSER=$ORA_OP_USER
ORAPASS=$ORA_OP_PASS
SYSDB="LMS��Ʈw[$ORAID]"

$ORACLE_HOME/bin/sqlplus -S /NOLOG <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE 
connect $ORA_OP_USER/$ORA_OP_PASS@$ORAID
quit
EOF

XX=$?

echo "---------------------------------------------------"
echo "          �t�θ�Ʈw���p�ʵ��e��       "
echo "---------------------------------------------------"

if [ $XX != 0 ]; then
	echo "\n Error : $SYSDB �s������ �� `date '+%Y/%m/%d %T'`"  
	echo "\n Error : $SYSDB �s������ �� `date '+%Y/%m/%d %T'`"  > $LOG_FILE
	exit 1
else
	echo "\n $SYSDB �s�����\ �� `date '+%Y/%m/%d %T'`...\n" 
	echo "\n $SYSDB �s�����\ �� `date '+%Y/%m/%d %T'`...\n" > $LOG_FILE
fi

