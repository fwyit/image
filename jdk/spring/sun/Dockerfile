FROM        alpine:jdk_8u111

ENV         APT_MIRROR=mirrors.aliyun.com

RUN         sed -i "s/dl-cdn.alpinelinux.org/$APT_MIRROR/g" /etc/apk/repositories && \
            apk update && \
            apk add --no-cache \
                net-tools \
                zip && \
            apk add --no-cache --virtual .dept \
                tzdata && \
            cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
            echo "Asia/Shanghai" > /etc/timezone && \
            apk del .dept && \
            rm -rf /var/cache/apk/*

ADD         app.sh /usr/bin/spring.sh
WORKDIR     /opt/
CMD         [ "spring.sh" ]

