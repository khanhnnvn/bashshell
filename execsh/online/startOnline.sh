#!/bin/sh

$HOME/execsh/online/stopOnline.sh

cd $WORK_DIR

# First entry in classpath is the Squirrel application.
TMP_CP=.

# Then add all library jars to the classpath.
for a in bin/*.jar; do
        TMP_CP="$TMP_CP":"$a";
done
for a in lib/*.jar; do
        TMP_CP="$TMP_CP":"$a";
done
for a in lib/dom4j-1.6.1/*.jar; do
        TMP_CP="$TMP_CP":"$a";
done
for a in lib/javamail-1.3.2/*.jar; do
        TMP_CP="$TMP_CP":"$a";
done
for a in lib/jaxb/*.jar; do
        TMP_CP="$TMP_CP":"$a";
done
for a in lib/cxf/*.jar; do
        TMP_CP="$TMP_CP":"$a";
done

nohup java -Dlog4j.configuration="config/loyaltys/log4.xml" -Xms128M -Xmx512M -cp $TMP_CP tw.com.hyweb.online.DefMain loyaltys &
#-Xgcpolicy:optavgpause #for multi cpu and reduct pause time
#-Xgcpolicy:gencon #for multi cpu and reduct pause time (mix mod with current and general)

