FROM        java:8u111-jdk-alpine

ENV         APT_MIRROR=mirrors.aliyun.com

RUN         sed -i "s/dl-cdn.alpinelinux.org/$APT_MIRROR/g" /etc/apk/repositories && \
            apk update && apk add zip && rm -rf /var/cache/apk/*

ADD         app.sh /usr/local/bin/app.sh
WORKDIR     /opt/
CMD         [ "/usr/local/bin/app.sh" ]

