FROM    fwyit/alpine:cn

RUN     repo ali && \
        apk update && \
        apk add --no-cache --virtual .deps \
            && \
        apk add --no-cache \
            php7-fpm \
            && \
        repo reset && \
        apk del .deps && \
        mkdir -p /var/www && \
        rm -rf /tmp/* /var/cache/apk/* /root/*

WORKDIR /var/www
EXPOSE  9000

ADD     init.sh /phpfpm
ENTRYPOINT '/phpfpm'