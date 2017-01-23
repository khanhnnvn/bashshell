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
ant -f runbatch.xml runSyncVNPTTables -Ddate=$RUN_DATE
ant -f runbatch.xml runCheckTopupCredit -Ddate=$RUN_DATE
ant -f runbatch.xml runInsertTermBatch -Ddate=$RUN_DATE
ant -f runbatch.xml runAutoTermBatchSettle -Ddate=$RUN_DATE
ant -f runbatch.xml runCutTopupTxn -Ddate=$RUN_DATE

# ImpAtmCard
#ant -f runbatch.xml runFtpIn -Ddate=$RUN_DATE -DfileName=ACCT
#ant -f runbatch.xml runFilesIn -Ddate=$RUN_DATE -DfileName=ACCT
#ant -f runbatch.xml runImpAtmCard -Ddate=$RUN_DATE
#ant -f runbatch.xml runFilesOut -Ddate=$RUN_DATE -DfileName=ACCT
#ant -f runbatch.xml runFtpOut -Ddate=$RUN_DATE -DfileName=ACCT

# ImpCardAcctMapping
ant -f runbatch.xml runFtpIn -Ddate=$RUN_DATE -DfileName=CARDACCTMAP
ant -f runbatch.xml runFilesIn -Ddate=$RUN_DATE -DfileName=CARDACCTMAP
ant -f runbatch.xml runImpCardAcctMapping -Ddate=$RUN_DATE

# ImpECMerch
ant -f runbatch.xml runFtpIn -Ddate=$RUN_DATE -DfileName=MERCH
ant -f runbatch.xml runFilesIn -Ddate=$RUN_DATE -DfileName=MERCH
ant -f runbatch.xml runImpECMerch -Ddate=$RUN_DATE
ant -f runbatch.xml runFilesOut -Ddate=$RUN_DATE -DfileName=MERCH
ant -f runbatch.xml runFtpOut -Ddate=$RUN_DATE -DfileName=MERCH

# perso related(total is 2)
ant -f runbatch.xml runProcPerso -Ddate=$RUN_DATE
ant -f runbatch.xml runExpPerso -Ddate=$RUN_DATE

# FilesOut, FtpOut
ant -f runbatch.xml runFilesOut -DfileName=PERSO -Ddate=$RUN_DATE
ant -f runbatch.xml runFtpOut -DfileName=PERSO -Ddate=$RUN_DATE

# new summary for VNPT
ant -f runbatch.xml runSumTopupMerch -Ddate=$RUN_DATE
ant -f runbatch.xml runSumTopupCredit -Ddate=$RUN_DATE

# housekeeping
ant -f runhousekeep.xml runLogBackup2File -Ddate=$RUN_DATE
ant -f runhousekeep.xml runDbBackup2HistoryAndDelete -Ddate=$RUN_DATE
