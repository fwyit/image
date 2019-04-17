#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来启动php-fpm

LISTEN=${LISTEN:=0.0.0.0}
sed -i "s/^listen.*/listen = $LISTEN:9000/g" /etc/php7/php-fpm.d/www.conf
php-fpm7 -t && php-fpm7 -FO