#!/usr/bin/sh

echo

cd $WORK_DIR

# First entry in classpath is the Squirrel application.
TMP_CP=.:build/classes

# Then add all library jars to the classpath.
for a in lib/*.jar; do
	TMP_CP="$TMP_CP":"$a";
done
for a in lib/dom4j-1.6.1/*.jar; do
	TMP_CP="$TMP_CP":"$a";
done
for a in lib/javamail-1.3.2/*.jar; do
	TMP_CP="$TMP_CP":"$a";
done
java -Dlog4j.configuration="./log4j.xml" -cp $TMP_CP tw.com.hyweb.core.cp.opmenu.DbConnTest 2> /dev/null

echo

