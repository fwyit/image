FROM    alpine

ENV     MIRROR=mirrors.aliyun.com

RUN     sed -i "s@dl-cdn.alpinelinux.org@$MIRROR@g" /etc/apk/repositories && \
        apk update && \
        apk add python3
