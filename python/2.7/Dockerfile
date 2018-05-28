FROM        python:2.7-alpine
MAINTAINER  Jam < liujianhncn@gmail.com >

ENV         MIRROR=mirrors.aliyun.com \
            NPM_MIRROR=registry.npm.taobao.org \
            PIP_MIRROR=mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

RUN         sed -i "s@dl-cdn.alpinelinux.org@$MIRROR@g" /etc/apk/repositories && \
            apk update && \
            apk add curl && \
            ap
            pipconf=~/.pip/pip.conf && \
            mkdir -p $(dirname $pipconf) &&  \
            echo "[global]" > $pipconf && \
            echo "index-url = https://$PIP_MIRROR" >> $pipconf
