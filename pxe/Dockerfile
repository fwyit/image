FROM        alpine
MAINTAINER  Jam < ops@doat.cc >

RUN         sed -i "s@dl-cdn.alpinelinux.org@repo.newbanker.cn@g" /etc/apk/repositories && \
            apk update && \
            apk add --no-cache \
                tftp-hpa \
                dhcp \
                openrc \
                syslinux && \
            rm -rf /var/cache/apk/*

ADD         init.sh /usr/bin/pxe
CMD         ["pxe"]
