FROM        alpine:jdk_8u111
MAINTAINER  Jam < ops@doat.cc >

RUN         sed -i "s@dl-cdn.alpinelinux.org@mirrors.aliyun.com@g" /etc/apk/repositories && \
            apk update && \
            apk add --no-cache --virtual .dept \
                tzdata && \
            cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
            echo "Asia/Shanghai" > /etc/timezone && \
            apk del .dept && \
            rm -rf /var/cache/apk/*
