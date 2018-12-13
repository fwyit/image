FROM        alpine:ali
MAINTAINER  Jam < ops@doat.cc >

RUN         apk update && \
            apk add --no-cache squid && \
            rm -rf /var/cache/apk/*

ADD         /default    /default
ADD         init.sh /usr/bin/squid.sh
CMD         ["/usr/bin/squid.sh"]
