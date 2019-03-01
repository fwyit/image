#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.1
#description : 本脚本主要用来启动应用服务

APP_NAME=${APP_NAME:=app}
APP_HOME=${APP_HOME:=/opt}
APP_PATH=${APP_PATH:=/app} CONF_DIR=${CONF_DIR:=/config}
LOG_PATH=${LOG_PATH:=/log}


app=$APP_HOME/${APP_NAME}.jar
LOG_FILE=$LOG_PATH/$APP_NAME.log

# 沿用老版本的JDK_MEM
test "$JDK_MEM" && JDKMEM=$JDK_MEM
JDKMEM=${JDKMEM:=512M}
timestamp=$(date +%Y%m%d%H%M)

test -d ${CONF_DIR:=/config} && confDir="$(cd $CONF_DIR; pwd)/"

_exit(){ echo "$@ ..." ; exit ;}

test -d $APP_PATH && APP=${APP:=$(find $APP_PATH -name '*jar' | head -n 1)}
# 强制从提供目录中获取应用程序
if test "$APP" -a -e "$APP" -a "$APP" != "$app"; then
    ln -f $APP $app || cp -f $APP $app
fi
test -e $app || _exit "未找到运行包程序$app..."

# 强制复写程序包
if test "$HACK" -o "$CLASS_BOOT"; then
    priv="$(stat -c %a $app)"
    CLASS_BOOT=${CLASS_BOOT:=BOOT-INF/classes}
    mkdir -p $CLASS_BOOT
    test -d /default && cp -rf /default/* $CLASS_BOOT/
    cp -rf $CONF_DIR/* $CLASS_BOOT/
    test -d $CLASS_BOOT && zip -ur $app $CLASS_BOOT/*
fi

mkdir -p $APP_HOME $LOG_PATH

JAVA_OPTS="-server -Xms$JDKMEM -Xmx$JDKMEM -Duser.timezone=GMT+08 -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 \
-verbose:gc -XX:NewRatio=3 -XX:SurvivorRatio=8 -XX:MaxMetaspaceSize=$JDKMEM -XX:+UseConcMarkSweepGC \
-XX:CompressedClassSpaceSize=$JDKMEM -XX:MaxTenuringThreshold=5 -XX:CMSInitiatingOccupancyFraction=70 \
-XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$LOG_PATH/server-gc.log.$timestamp -XX:+UseGCLogFileRotation \
-XX:NumberOfGCLogFiles=1 -XX:GCLogFileSize=$JDKMEM -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

test "$CLASS_BOOT" && test "$BOOT_CLASS" && java $JAVA_OPTS -cp $BOOT_CLASS:$app $CLASS_BOOT

#test "$confDir" && test -d $confDir && SPRING_OPTS="--spring.config.location=$confDir $SPRING_OPTS "
test "$confDir" && test -d $confDir && SPRING_OPTS="--spring.config.location=classpath:/,file:$confDir $SPRING_OPTS "

cd $APP_HOME

test -e $LOG_FILE && mv $LOG_FILE ${LOG_FILE%.log}.$timestamp.log && echo "成功备份原始日志"

cmd="java $JAVA_OPTS -jar $app $SPRING_OPTS --logging.file=$LOG_FILE "
echo 
echo "$cmd"
echo
$cmd
test "$DEBUG" && tail -f /etc/hosts

