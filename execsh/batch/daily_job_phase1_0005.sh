#!/usr/bin/ksh

# System environment configuration
# Batch home directory
# Batch run date
RUN_DATE=`date +%Y%m%d`

RUN_MENU=no
. ~/.profile
RUN_DATE=`date +%Y%m%d`

cd $WORK_DIR

# new for VNPT phase I
ant -f runbatch.xml runInsertTermBatch -Ddate=$RUN_DATE
