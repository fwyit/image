#!/usr/bin/env sh

set -e
APP=${APP:=logstash}
echo "ELK Home: ${LS_HOME:=/opt/$APP}"
echo "ELK User: ${LS_USER:=$APP}"

cd $LS_HOME
test -d ${CONF_DIR:=/config} && cp -rf $CONF_DIR/* $LS_HOME/config
test -e $CONF_DIR/logstash.conf || cp $CONF_DIR/logstash-sample.conf $CONF_DIR/logstash.conf
if [ "${1:0:1}" = '-' ]; then
    set -- logstash "$@"
fi

if [ "$1" = 'logstash' -a "$(id -u)" = '0' ]; then
    for path in data logs config; do
        chown -R $LS_USER:$LS_USER "$path"
    done
    
    set -- su-exec $LS_USER "$@"
fi

exec "$@"