FROM    alpine:python3

RUN     apk update && \
        apk add --no-cache \
            libxml2 \
            libxslt && \
        apk add --no-cache --virtual .dep \
            gcc \
            linux-headers \
            libxml2-dev \
            libxslt-dev \
            libc-dev \
            libffi-dev \
            openssl-dev && \
        ln -f /usr/local/bin/python3 /usr/local/bin/python ; \
        pip install cryptography ; \
        pip install lxml; \
        pip install scrapyd ; \
        apk del .dep && \
        rm -rf ~/.cache