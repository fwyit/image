FROM    fwyit/alpine:php

RUN     repo ali && \
        apk update && \
        apk add --no-cache \
            perl \
            perl-fcgi \
            perl-encode \
            curl \
            && \
        repo reset && \
        rm -rf /tmp/* /var/cache/apk/* /root/*

ENV     AWS_VER=7.7

RUN     cd /tmp/ && \
        app=awstats-${AWS_VER}.tar.gz && \
        curl -Lo $app https://prdownloads.sourceforge.net/awstats/$app && \
        mkdir -p /usr/local && \
        tar -zxvf $app -C /usr/local && \
        ln -sf /usr/local/awstats-${AWS_VER} /usr/local/awstats && \
        cp -rf /usr/local/awstats/wwwroot/* /var/www/ && \
        cp -f /usr/local/awstats/tools/nginx/awstats-fcgi.php /var/www/cgi-bin/fcgi.php
