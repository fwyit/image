#!/bin/sh

test "$(which awstats.pl 2>/dev/null)" || export PATH=/usr/local/awstats/wwwroot/cgi-bin/:$PATH
awstats="$(which awstats.pl)"
test "$(grep methodurl -C 5 $awstats | grep ']+|')" && sed -i 's/]+|/]+/' $awstats

create(){
    domain=$1 && shift
    echo "获取到本次需要处理的域名为: $domain"
    test ! -e /etc/awstats/awstats.$domain.conf && echo "未找到配置文件 $domain" && exit 1
    mkdir -p ${WEB_DIR:=/opt/web/stat}/$domain
    # /usr/local/awstats/tools/awstats_buildstaticpages.pl -config=$domain -lang=cn $@
    $awstats -config=$domain
    /usr/local/awstats/tools/awstats_buildstaticpages.pl -config=$domain -dir=${WEB_DIR}/$domain -lang=cn $@
    ln -sf awstats.$domain.html  /opt/web/stat/$domain/index.html  
}

getAllDomainFromConf(){
    for domain in `ls /etc/awstats/ | grep awstats | grep conf | sed -e 's/awstats.//g' -e 's/.conf//g'`; do
        echo "本次获取到 $domain"
        create $domain
    done
}

getAllDomainFromDemo(){
    cd /etc/awstats/
    test ! -e demo.conf && echo "未找到demo配置文件 demo.conf" && exit 1
    site=$(grep ^SiteDomain demo.conf | cut -d'"' -f2 | sort | uniq)
    logs="$(grep ^LogFile demo.conf | cut -d'"' -f2 | sort | uniq)"
    for log in $logs; do
        test -e $log || continue
        echo "本次获取到日志 $log"
        domains=$(awk -F'\t' '{print $6}' $log | sort | uniq)
        for domain in $domains; do
            echo "准备更新域名 $domain"
            cp demo.conf awstats.$domain.conf
            sed -i "s/$site/$domain/g" awstats.$domain.conf
        done
    done
}

startServer(){ mkdir -p /run/nginx && nginx && tail -f /var/log/nginx/access.log; }

case $1 in
    t) create service-wbs242.newtamp.cn -update ;;
    a) getAllDomainFromDemo ;;
    c) getAllDomainFromConf ;;
    p) /phpfpm ;;
    s) startServer ;;
    sh|bash) exec sh ;;
    ?) startServer ;;
    *) create $1 ;;
esac
