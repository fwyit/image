FROM    alpine:python3
# alpine/python/3.6

RUN     apk update && \
        apk add --no-cache --virtual .deps \
            gcc \
            linux-headers \
            libxml2-dev \
            libxslt-dev \
            libc-dev \
            && \
        apk add libxslt && \
        pip install lxml==4.3.1 && \
        apk del .deps && \
        rm -rf ~/.cache /tmp/*

