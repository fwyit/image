#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来启动nexus

JDK_MEM=${JDK_MEM:=1024M}
test "$(id -u nexus 2>/dev/null)" || adduser -D nexus
APP_HOME=${APP_HOME:=/opt/nexus-$NEXUS_VER}
conf=$APP_HOME/bin/nexus.vmoptions
if test -e $conf; then
    sed -i \
        -e "s/-Xms.*/-Xms$JDK_MEM/" \
        -e "s/-Xmx.*/-Xmx$JDK_MEM/" \
        -e "s@-Dkaraf.data=.*@-Dkaraf.data=$NEXUS_HOME@" \
    $conf
fi
su nexus -c "$APP_HOME/bin/nexus run"