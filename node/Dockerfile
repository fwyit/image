FROM        node:8-alpine
MAINTAINER  Jam < ops@doat.cc >

ENV         MIRROR=mirrors.aliyun.com \
            NPM_MIRROR=registry.npm.taobao.org

RUN         sed -i "s@dl-cdn.alpinelinux.org@$MIRROR@g" /etc/apk/repositories && \
            apk update && \
            apk add curl 
