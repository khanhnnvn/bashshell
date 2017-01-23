#!/usr/bin/ksh

# System environment configuration
# Batch home directory
# Batch run date
RUN_DATE=`date +%Y%m%d`

RUN_MENU=no
. ~/.profile
RUN_DATE=`date +%Y%m%d`

cd $WORK_DIR

# FtpIn, FilesIn
ant -f runbatch.xml runFtpIn -Ddate=$RUN_DATE
ant -f runbatch.xml runFilesIn -Ddate=$RUN_DATE

# ImpXXX(total is 14), ProcAppointList
ant -f runbatch.xml runImpCard -Ddate=$RUN_DATE
ant -f runbatch.xml runImpHolder -Ddate=$RUN_DATE
ant -f runbatch.xml runImpCrdSta -Ddate=$RUN_DATE
ant -f runbatch.xml runImpCardReplace -Ddate=$RUN_DATE
ant -f runbatch.xml runImpCardAssociator -Ddate=$RUN_DATE
ant -f runbatch.xml runImpCardAssociatorReplace -Ddate=$RUN_DATE
ant -f runbatch.xml runImpMerch -Ddate=$RUN_DATE
ant -f runbatch.xml runImpTerm -Ddate=$RUN_DATE
ant -f runbatch.xml runImpStoreCounter -Ddate=$RUN_DATE
ant -f runbatch.xml runImpTrans -Ddate=$RUN_DATE
ant -f runbatch.xml runImpAppointList -Ddate=$RUN_DATE
ant -f runbatch.xml runProcAppointList -Ddate=$RUN_DATE
ant -f runbatch.xml runImpProgList -Ddate=$RUN_DATE
ant -f runbatch.xml runImpAppload -Ddate=$RUN_DATE
ant -f runbatch.xml runImpPromotionMsg -Ddate=$RUN_DATE

# preprocessing(total is 7)
ant -f runbatch.xml runSimulateAppointReloadDownload -Ddate=$RUN_DATE
ant -f runbatch.xml runSimulateBalTransferDownload -Ddate=$RUN_DATE
ant -f runbatch.xml runExtendCouponChipBase -Ddate=$RUN_DATE
ant -f runbatch.xml runExtendCouponHostBase -Ddate=$RUN_DATE
ant -f runbatch.xml runSimulateCardReturn -Ddate=$RUN_DATE
ant -f runbatch.xml runCleanCardBalance -Ddate=$RUN_DATE
ant -f runbatch.xml runGenerateKEKKeyVersion -Ddate=$RUN_DATE

# online txn error handling(total is 3)
ant -f runbatch.xml runProcOnlTxnErr -Ddate=$RUN_DATE
ant -f runbatch.xml runProcUnbalTermBatch -Ddate=$RUN_DATE
ant -f runbatch.xml runPatchUnbalTermBatch -Ddate=$RUN_DATE

# new for VNPT phase I
ant -f runbatch.xml runSyncVNPTTables -Ddate=$RUN_DATE
ant -f runbatch.xml runCheckTopupCredit -Ddate=$RUN_DATE
ant -f runbatch.xml runInsertTermBatch -Ddate=$RUN_DATE
ant -f runbatch.xml runAutoTermBatchSettle -Ddate=$RUN_DATE
ant -f runbatch.xml runCutTopupTxn -Ddate=$RUN_DATE

# daycut(total is 4)
ant -f runbatch.xml runCutOnlTxnStandard -Ddate=$RUN_DATE
ant -f runbatch.xml runCutCheckTxn -Ddate=$RUN_DATE
ant -f runbatch.xml runCutAdjustTxn -Ddate=$RUN_DATE
ant -f runbatch.xml runCutCapturedTxn -Ddate=$RUN_DATE

# CheckOfflineTxn
ant -f runbatch.xml runCheckOfflineTxn -Ddate=$RUN_DATE

# ProcBalance
ant -f runbatch.xml runProcBalance -Ddate=$RUN_DATE

# ProcSettle
ant -f runbatch.xml runProcSettle -Ddate=$RUN_DATE

# ProcFee
ant -f runbatch.xml runProcFee -Ddate=$RUN_DATE

# perso related(total is 2)
ant -f runbatch.xml runProcPerso -Ddate=$RUN_DATE
ant -f runbatch.xml runExpPerso -Ddate=$RUN_DATE

# FilesOut, FtpOut
ant -f runbatch.xml runFilesOut -Ddate=$RUN_DATE
ant -f runbatch.xml runFtpOut -Ddate=$RUN_DATE

# ProcParm
ant -f runbatch.xml runProcParm -Ddate=$RUN_DATE

# CheckQuotaAlert
ant -f runbatch.xml runCheckQuotaAlert -Ddate=$RUN_DATE

# summary related(total is 6)
ant -f runbatch.xml runSumBonus -Ddate=$RUN_DATE
ant -f runbatch.xml runSumCardProduct -Ddate=$RUN_DATE
ant -f runbatch.xml runSumMerch -Ddate=$RUN_DATE
ant -f runbatch.xml runSumPbnld -Ddate=$RUN_DATE
ant -f runbatch.xml runSumCardStatus -Ddate=$RUN_DATE
ant -f runbatch.xml runSumIssPb -Ddate=$RUN_DATE

# new summary for VNPT
ant -f runbatch.xml runSumTopupMerch -Ddate=$RUN_DATE
ant -f runbatch.xml runSumTopupCredit -Ddate=$RUN_DATE

# housekeeping
ant -f runhousekeep.xml runLogBackup2File -Ddate=$RUN_DATE
ant -f runhousekeep.xml runDbBackup2File -Ddate=$RUN_DATE
ant -f runhousekeep.xml runDbBackup2HistoryAndDelete -Ddate=$RUN_DATE
ant -f runhousekeep.xml runDbBackup2History -Ddate=$RUN_DATE
ant -f runhousekeep.xml runDbTruncate -Ddate=$RUN_DATE
ant -f runhousekeep.xml runDbUpdate -Ddate=$RUN_DATE
ant -f runhousekeep.xml runDbDelete -Ddate=$RUN_DATE
ant -f runhousekeep.xml runHouseKeepTermParVer -Ddate=$RUN_DATE
