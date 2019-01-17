#!/usr/bin/env sh

set -e
APP=${APP:=kibana}
echo "ELK Home: ${KB_HOME:=/opt/$APP}"
echo "ELK User: ${KB_USER:=$APP}"

cd $KB_HOME
test -d ${CONF_DIR:=/config} && cp -rf $CONF_DIR/* $KB_HOME/config


if [ "${1:0:1}" = '-' ]; then
    set -- $KB_USER "$@"
fi

if [ "$1" = "$KB_USER" -a "$(id -u)" = '0' ]; then
    for path in data logs config; do
        chown -R $KB_USER:$KB_USER "$path"
    done
    
    set -- su-exec $KB_USER "$@"
fi

exec "$@"