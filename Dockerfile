FROM    fwyit/alpine:cn

RUN     repo ali && \
        apk update && \
        apk add --no-cache --virutal .deps \
            \
        repo reset && \
        apk del .deps && \
        rm -rf /tmp/* /var/cache/apk/* /root/*

ADD     init.sh /entrypoint.sh
ENTRYPOINT ['/entrypoint.sh']