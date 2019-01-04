#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来快速搭建pxe系统

NET_HOME=${NET_HOME:=192.168.16.0}
SUB_MASK=${SUB_MASK:=24}
NET_DOMAIN=${NET_DOMAIN:=cc}
DATA_DIR=${DATA_DIR:=/var/tftpboot/}
case $SUB_MASK in
    24) NET_MASK=255.255.255.0 ;;
esac

lastIP=${NET_HOME##*.}
preIP=${NET_HOME%.*}
NET_ROUTE="$preIP.$(echo $((lastIP+1)))"
NET_START="$preIP.$(echo $((lastIP+10)))"
NET_END="$preIP.$(echo $((lastIP+20)))"
NET_NEXT="$preIP.$(echo $((lastIP+3)))"
NET_SERV="$preIP.252"

cat > /etc/dhcpd.conf <<-EOF
ddns-update-style interim;
ignore client-updates;
allow booting;
allow bootp;
subnet $NET_HOME netmask $NET_MASK
{
    option routers $NET_ROUTE;
    option domain-name "$NET_DOMAIN";
    option domain-name-servers $NET_SERV;
    option subnet-mask $NET_MASK;
    option time-offset -18000;
    default-lease-time 21600;
    max-lease-time 43200;
    range dynamic-bootp $NET_START $NET_END;
    filename "pxelinux.0";
    next-server $NET_NEXT;
}
EOF
mkdir -p /var/lib/dhcp/


cat > /etc/init.d/in.tftpd <<EOF
INTFTPD_PATH="$DATA_DIR"
INTFTPD_OPTS="-R 4096:32767 -s ${DATA_DIR}"
EOF

echo "准备启动DHCP服务...."
/etc/init.d/dhcpd start

echo "准备启动TFTP服务...."
/etc/init.d/in.tftpd start