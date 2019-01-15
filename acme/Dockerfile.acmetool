FROM        alpine
MAINTAINER  Jam <liujianhncn@gmail.com>

ENV         ACME_VER=v0.0.67 \
            ACME_URL=https://github.com/hlandau/acme/releases/download

RUN         sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
            apk update && \
            apk add --no-cache ca-certificates && \
            wget $ACME_URL/$ACME_VER/acmetool-${ACME_VER}-linux_amd64.tar.gz -O acmetool.tgz && \
            tar -zxf acmetool.tgz && \
            mv acmetool-${ACME_VER}-linux_amd64/bin/acmetool /usr/bin/acmetool && \
            acmetool status && \
            rm -rf acmetool.tgz acmetool-${ACME_VER}-linux_amd64

VOLUME      /var/lib/acme /usr/lib/acme/hooks
WORKDIR     /var/lib/acme
