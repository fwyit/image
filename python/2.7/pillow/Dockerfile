FROM    fwyit/alpine:cn

RUN     repo ali && \
        apk update && \
        apk add --no-cache \
            python \
            libxml2 \
            libxslt && \
        apk add --no-cache --virtual .deps \
            gcc \
            py2-pip \
            python-dev \
            linux-headers \
            libxml2-dev \
            libxslt-dev \
            libc-dev \
            jpeg-dev \
            zlib-dev \
            libffi-dev \
            openssl-dev \
            && \
        python -m pip install -i https://pypi.douban.com/simple/ pillow && \
        repo reset && \
        apk del .deps && \
        rm -rf /tmp/* /var/cache/apk/* /root/*
