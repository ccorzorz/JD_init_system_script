#!/bin/bash
set -x
set -o nounset
set -o errexit

USER="admin"
CHOWN="chown -R admin:admin"
egrep "^$USER" /etc/passwd

MKDIR="mkdir -p"
BASE_DIR="/export/servers"
USER="admin"
LINK="ln -s"
if [ $# -lt 2 ] 
then
    echo "help:./init.sh <jdk-version> <tomcat-version>"
    echo "help: jdk version [1.6 | 1.7 | 1.8]; tomcat version [6 7 8]"
    echo "example:./init.sh 1.6 7"
    exit 1
fi

JDK=$1
TOMCAT=$2

if [ "$JDK"X = "1.6"X -o "$JDK"X = "1.7"X -o "$JDK"X = "1.8"X ]
then
    echo "JDK version:"$JDK
else
    echo "JDK version [ 1.6 | 1.7 | 1.8], please input again"
    exit 1
fi

if [ "$TOMCAT"X = "6"X -o "$TOMCAT"X = "7"X -o "$TOMCAT"X = "8"X ]
then
    echo "TOMCAT version:"$TOMCAT
else
    echo "TOMCAT version [ 6 | 7 | 8], please input again"
    exit 1
fi

$MKDIR $BASE_DIR

case $JDK in
    "1.6" )
	J_VERSION=1.6.0_25
	;;
    "1.7" )
	J_VERSION=1.7.0_71
	;;
    "1.8" )
	J_VERSION=1.8.0_20
	;;
esac

case $TOMCAT in
    "6" )
	T_VERSION=6.0.33
	;;
    "7" )
	T_VERSION=7.0.61
	;;
    "8" )
	T_VERSION=8.0.30
	;;
esac

J_DIR=$BASE_DIR/jdk$J_VERSION
T_DIR=$BASE_DIR/tomcat$T_VERSION
DOWNURL="curl -fSsL http://oss.cn-north-1.jcloudcs.com/open-tools"
J_LINK=$BASE_DIR/jdk
T_LINK=$BASE_DIR/tomcat

if [ ! -d "$J_DIR" ]
then
    $DOWNURL/jdk$J_VERSION.tar.gz | tar -xzf - --strip-components=1 -C $BASE_DIR
    $LINK $J_DIR /export/servers/jdk
    $CHOWN $J_LINK
fi  

if [ ! -d "$T_DIR" ]
then
    $DOWNURL/tomcat$T_VERSION.tar.gz | tar -xzf - --strip-components=1 -C $BASE_DIR
    $LINK $T_DIR /export/servers/tomcat
    $CHOWN $T_LINK
fi  

FILE_ENV=/etc/profile.d/1-java.sh
export JAVA_HOME=/export/servers/jdk
if [ ! -f "$FILE_ENV" ]
then
    echo "export PATH=$JAVA_HOME/bin:$PATH" >> $FILE_ENV
    echo "export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> $FILE_ENV
    echo "export JAVA_OPTS=\"-server -Xms1024m -Xmx2048m -XX:MaxPermSize=256m\
 -Djava.awt.headless=true -Dsun.net.client.defaultReadTimeout=60000 -Djmagick.systemclassloader=no -Dnetworkaddress.cache.ttl=300 -Dsun.net.inetaddr.ttl=300\"" >>$FILE_ENV 
fi

$CHOWN /export
