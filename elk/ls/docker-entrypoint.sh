#!/bin/env sh

set -e
echo "Elasticsearch Home: ${ES_HOME:=/opt/elasticsearch}"
echo "Elasticsearch User: ${ES_USER:=elasticsearch}"

cd $ES_HOME
test -d ${CONF_DIR:=/config} && cp -rf $CONF_DIR/* $ES_HOME/config

if [ "${1:0:1}" = '-' ]; then
    set -- elasticsearch "$@"
fi

if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
    for path in data logs ; do
        chown -R $ES_USER:$ES_USER "$path"
    done
    
    set -- su-exec $ES_USER "$@"
fi

exec "$@"