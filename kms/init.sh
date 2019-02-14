#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来启动kms

BASE="$@"
OPTS=${OPTS:=''}
HOST=${HOST:='0.0.0.0'}
PORT=${PORT:=10080}
HWID=${HWID:=random}
BASE=${BASE:="$HOST $PORT"}

cmd="python server.py $OPTS -w $HWID -s $BASE"

test "$1" != 'sh' && echo $cmd && eval $cmd || exec sh

