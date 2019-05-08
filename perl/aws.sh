#!/bin/sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来创建awstats项目

test "$(which awstats.pl 2>/dev/null)" || export PATH=/usr/local/awstats/wwwroot/cgi-bin/:$PATH
awstats="$(which awstats.pl)"
test "$(grep methodurl -C 5 $awstats | grep ']+|')" && sed -i 's/]+|/]+/' $awstats
mkdir -p /etc/awstats/
## 处理非正常访问
test -e /etc/awstats/awstats._.conf && rm -f /etc/awstats/awstats._.conf
ts=%(date +%Y%m%d)

create(){
    domain=$1 && shift
    echo "获取到本次需要处理的域名为: $domain"
    conf="/etc/awstats/awstats.$domain.conf"
    test ! -e $conf && echo "未找到配置文件 $domain" && exit 1
    mkdir -p ${WEB_DIR:=/opt/web/stat}/$domain
    $awstats -config=$domain $@ 2>> $(grep ^LogFile $conf | cut -d'"' -f2 | tail -n 1)/../err.$ts.log
    /usr/local/awstats/tools/awstats_buildstaticpages.pl -config=$domain -dir=${WEB_DIR}/$domain -lang=cn $@
    ln -sf awstats.$domain.html  /opt/web/stat/$domain/index.html
}

getAllDomainFromConf(){
    all=""
    for domain in `ls /etc/awstats/ | grep awstats | grep conf | sed -e 's/awstats.//g' -e 's/.conf//g'`; do
        echo "本次获取到 $domain"
        all="$all $domain"
        create $domain $@
    done
    test -z "$all" && echo "未找到待处理的域名，请核实配置信息..." && _help && exit 3
}

getAllDomainFromDemo(){
    cd /etc/awstats/
    test ! -e demo.conf && echo "未找到demo配置文件 demo.conf" && exit 1
    site=$(grep ^SiteDomain demo.conf | cut -d'"' -f2 | sort | uniq)
    logs="$(grep ^LogFile demo.conf | cut -d'"' -f2 | sort | uniq)"
    test -z "$(grep $site $logs)" && echo "未找到demo中的有效域名，请核查..." && exit 3
    index="$(grep ^LogFormat demo.conf | cut -d'"' -f2 | tail -n 1 | awk '{for(;i++<NF;){ if($i=="%virtualname"){ print i;exit;}}}')"
    echo "本次获取到域名所在位置为: $index"
    for log in $logs; do
        test -e $log || continue
        echo "本次获取到日志 $log"
        domains=$(awk -F'\t' "{print \$$index}" $log | sort | uniq)
        for domain in $domains; do
            test "$domain" == "_" && continue
            echo "准备更新域名 $domain"
            cp demo.conf awstats.$domain.conf
            sed -i "s/$site/$domain/g" awstats.$domain.conf
        done
    done
}

startServer(){ test "$(which nginx 2>/dev/null)" && mkdir -p /run/nginx && nginx && tail -f /var/log/nginx/access.log; }
_help(){
    echo "t     测试某域名"
    echo "a     从demo文件中生成所有域名"
    echo "c     从路径下处理所有域名"
    echo "C     从路径下处理所有域名(更新方式)"
    echo "域名   处理某个域名下信息..."
}

case $1 in
    t) create service-wbs242.newtamp.cn -update ;;
    a) getAllDomainFromDemo ;;
    c) shift && getAllDomainFromConf $@ ;;
    C) shift && getAllDomainFromConf -update $@ ;;
    p) /phpfpm ;;
    s) startServer ;;
    h) _help ;;
    sh|bash) exec sh ;;
    ?) startServer ;;
    *) create $1 ;;
esac
