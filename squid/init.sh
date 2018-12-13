#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来启动squid

SQUID_CONF_DIR=/etc/squid/
test -d $SQUID_CONF_DIR || apk add squid
test -d /default && cp -rf /default/* $SQUID_CONF_DIR
test -d ${CONF_DIR:=/config} && cp -rf $CONF_DIR/* $SQUID_CONF_DIR

conf=$SQUID_CONF_DIR/squid.conf
test "${PORT}" && sed -i "s/^http_port.*/http_port $PORT/" $conf

i=0
for proxy in $(eval echo $PEERS); do
    i=$((i+1))
    h=${proxy%%:*}
    p=${proxy##*:}
    test "$(grep $h $conf | grep $p)" || sed -i "/deny all/a\cache_peer $h parent $p 0 no-query allow-miss max-conn=5 name=client_$i" $conf
done

for host in $(eval echo $WHITELIST); do
    test "$(grep $host $conf)" || sed -i "2a\acl whitelist src $host" $conf
done

test "$WHITELIST" && sed -i "/allow connect/a\http_access allow whitelist" $conf

squid -N -a ${PORT:=3128}
