#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来启动choice


APP_DIR=${APP_DIR:=/opt}
CONFILE=$APP_DIR/core/app/config.py
APPNAME=${APPNAME:=/app.zip}
ln -sf `realpath /usr/share/zoneinfo/Asia/Shanghai` /etc/localtime
echo "Asia/Shanghai" > /etc/timezone

test -d $APP_DIR || mkdir $APP_DIR
test -e $APPNAME && unzip -o $APPNAME -d $APP_DIR
test -d /config && cp -rf /config/* $APP_DIR

cd $APP_DIR

find . -name "__pycache__" -exec rm -rf {} \;

installScript=$APP_DIR/core/engine/choice/installEmQuantAPI_Ex.py
test -e $installScript && python $installScript

test -z "$(grep 'from local import' $CONFILE)" \
    && echo "from local import *" >> $CONFILE \
    && test -e /config.local.py \
    && cat /config/local.py > $(dirname $CONFILE)/local.py

test -e $APP_DIR/requirements.txt \
    && pip install -i ${PIP_MIRROR:=https://pypi.douban.com/simple} \
        -r $APP_DIR/requirements.txt

sed -i 's/127.0.0.1/0.0.0.0/' manage.py
python manage.py runserver
