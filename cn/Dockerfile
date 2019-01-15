FROM        alpine:glibc
MAINTAINER  Jam < ops@doat.cc >

ADD         ./repo /usr/bin/repo
RUN         repo ali && \
            apk update && \
            apk add --no-cache --virtual .dept \
                tzdata && \
            cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
            echo "Asia/Shanghai" > /etc/timezone && \
            apk del .dept && \
            repo re && \
            rm -rf /var/cache/apk/*
