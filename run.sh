#!/bin/sh

### Factors that affect JVM performance
### Heap and stack sizes (-Xms, -Xmx, -Xss, and -Xoss settings).
### The search path to the class libraries (classpath  and  most-used  classes  should come first).
### Garbage  collection  activity.
### The quality of the application code.
### Just-in-Time compiler.
### The machine configuration:
### ¡V I/O  disk  size  and  speed
### ¡V Number  and  speed  of  CPUs
### ¡V Processor  cache  size  and  speed
### ¡V Random  access  memory  size  and  speed
### ¡V Network  and  network  adapters  number  and  speed

### for show gc information ###
#-verbose:gc

### for log gc information ###
#-Xloggc:gc.log

### for multi cpu and reduct pause time ###
#-Xgcpolicy:optavgpause

### for multi cpu and reduct pause time (mix mod with current and general) ###
#-Xgcpolicy:gencon

### for jprofiler ###
#LIBPATH=$LIBPATH:/home/edp81438/jprofiler5/bin/aix-ppc64;export LIBPATH
#-agentlib:jprofilerti= -Xbootclasspath/a:/home/edp81438/jprofiler5/bin/agent.jar

### for JMX jconsole ###
#-Dcom.sun.management.jmxremote

# First entry in classpath is the Squirrel application.
TMP_CP=.

# Then add all library jars to the classpath.

for a in bin/*; do
    TMP_CP="$TMP_CP":"$a";
done
for a in lib/*; do
    TMP_CP="$TMP_CP":"$a";
done
for a in lib/dom4j-1.6.1/*; do
    TMP_CP="$TMP_CP":"$a";
done
for a in lib/oracleaq/*; do
    TMP_CP="$TMP_CP":"$a";
done
for a in lib/json/*; do
    TMP_CP="$TMP_CP":"$a";
done
java -Dlog4j.configuration="config/$1/log4.xml" -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=5678 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xms96M -Xmx512M -cp $TMP_CP tw.com.hyweb.online.DefMain $@
