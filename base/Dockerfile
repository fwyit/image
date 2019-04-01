FROM    fwyit/alpine:cn

RUN     repo ali && \
        repo reset && \
        rm -rf /tmp/* /var/cache/apk/* /root/*

ADD     init.sh /entrypoint.sh
ENTRYPOINT ['/entrypoint.sh']