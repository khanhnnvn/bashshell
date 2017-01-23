#!/bin/sh

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

java -cp $TMP_CP tw.com.hyweb.util.CipherUtil $@
