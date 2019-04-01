FROM    fwyit/alpine:cn

RUN     repo ali && \
        apk update && \
        apk add --no-cache \
            python \
            && \
        apk add --no-cache --virtual .deps\
            gcc \
            g++ \
            python-dev \
            && \
        python -m pip install sentry django-sentry -i https://pypi.douban.com/simple/ && \
        repo reset && \
        apk del .deps && \
        rm -rf /tmp/* /var/cache/apk/* /root/*

ADD     init.sh /entrypoint.sh
ENTRYPOINT ['/entrypoint.sh']