#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来启动arthas应用

ARTHAS_HOME=~/.arthas/lib
ARTHAS_ARGS=$@

test "$DEBUG" && echo "准备运行demo程序..." && java -jar $ARTHAS_HOME/arthas-demo.jar > /tmp/demo.log &
pid="$(ps -ef | grep java | grep -v grep | awk '{print $1}')"
test -z "$pid" && echo "未找到当前系统启用java进程，准备退出..." && exit 2
test "$ARTHAS_ARGS" || ARTHAS_ARGS=$pid
java -jar $ARTHAS_HOME/arthas-boot.jar $ARTHAS_ARGS