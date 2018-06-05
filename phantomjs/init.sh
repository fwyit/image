    sed -i "s@dl-cdn.alpinelinux.org@mirrors.aliyun.com@g" /etc/apk/repositories && \    
    apk update && \
    apk add --no-cache --virtual .build-deps \
        freetype-dev \
        libjpeg-turbo-dev \
        icu-dev \
        gcc \
        git \
        paxctl \
        make \
        openssl-dev \
        sqlite-dev \
        perl \
        g++ \
        libx11-dev \
        flex \
        libxext-dev \
        gperf \
        python \
        build-base \
        linux-headers \
        ruby \
        bash \
        libjpeg \
        libpng-dev \
        fontconfig-dev \
        bison \
        libexecinfo-dev \
        libc-dev &&
    GLIB_HOME=/usr/glibc-compat && \
    export PATH=$GLIB_HOME/bin:$GLIB_HOME/sbin:$PATH && \
    export LD_LIBRARY_PATH=$GLIB_HOME/lib:$LD_LIBRARY_PATH && \
    PHJS_HOME=/usr/src/phantomjs && \
    cd $PHJS_HOME && \
    chown -R root:root . && \
    PATCH_DIR=/patch && \
    for i in qtbase qtwebkit; do \
        cd $PHJS_HOME/src/qt/$i && patch -p1 -i $PATCH_DIR/${i}*.patch || break; \
    done && \
    cd $PHJS_HOME && patch -p1 -i $PATCH_DIR/build.patch && \
    python build.py -d --confirm && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* $PHJS_HOME $PATCH_DIR
