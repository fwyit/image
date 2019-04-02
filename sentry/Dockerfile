FROM    fwyit/alpine:cn

RUN     repo ali && \
        apk update && \
        apk add --no-cache \
            python \
            && \
        apk add --no-cache --virtual .deps \
            python2-dev \
            musl-dev \
            linux-headers \
            py2-pip \
            gcc \
            g++ \
            curl \
            postgresql-dev \
            libffi-dev \
            libxml2-dev \
            libxslt-dev \
            libc-dev \
            jpeg-dev \
            zlib-dev \
            libffi-dev \
            && \
        cd /tmp/ && \
        curl -LO https://raw.githubusercontent.com/getsentry/sentry/master/requirements-base.txt && \
        index=https://pypi.douban.com/simple/ && \
        python -m pip install -i $index milksnake 'pytest<3.6' && \
        python -m pip install -i $index 'pillow<=4.2.1' && \
        python -m pip install -i $index -r requirements-base.txt && \
        repo reset && \
        apk del .deps && \
        rm -rf /tmp/* /var/cache/apk/* /root/*

RUN     repo ali && \
        apk update && \
        apk add --no-cache \
            python \
            libxml2 \
            libxslt && \
        apk add --no-cache --virtual .dep \
            gcc \
            && \
        repo reset && \
        apk del .deps && \
        rm -rf /tmp/* /var/cache/apk/* /root/*

ADD     init.sh /entrypoint.sh
ENTRYPOINT ['/entrypoint.sh']