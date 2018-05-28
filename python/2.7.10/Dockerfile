FROM        alpine:3.4

ENV         PATH=/usr/local/bin:$PATH \
            LANG=C.UTF-8 \
            MIRROR=mirrors.aliyun.com \
            PYTHON_MIRROR=mirrors.sohu.com \
            PYTHON_VERSION=2.7.10 \
            GPG_KEY=C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

RUN         sed -i "s@dl-cdn.alpinelinux.org@$MIRROR@g" /etc/apk/repositories && \
            apk update && \
            apk add --no-cache ca-certificates && \
            set -ex && \
            apk add --no-cache --virtual .fetch-deps \
                gnupg \
                openssl \
                tar \
                xz && \
            wget -O python.tar.xz "$PYTHON_MIRROR/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" && \
            wget -O python.tar.xz.asc "$PYTHON_MIRROR/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" && \
            export GNUPGHOME="$(mktemp -d)" && \
            gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" && \
            gpg --batch --verify python.tar.xz.asc python.tar.xz && \
            rm -rf "$GNUPGHOME" python.tar.xz.asc && \
            mkdir -p /usr/src/python && \
            tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz && \
            rm python.tar.xz && \
            apk add --no-cache --virtual .build-deps  \
             bzip2-dev \
             coreutils \
             dpkg-dev dpkg \
             gcc \
             gdbm-dev \
             libc-dev \
             linux-headers \
             make \
             ncurses-dev \
             openssl \
             openssl-dev \
             pax-utils \
             readline-dev \
             sqlite-dev \
             tcl-dev \
             tk \
             tk-dev \
             zlib-dev \
             && \
            apk del .fetch-deps && \
            cd /usr/src/python && \
            gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
            ./configure \
                --build="$gnuArch" \
                --enable-shared \
                --enable-unicode=ucs4 && \
            make -j "$(nproc)" && \
            make install && \
            runDeps="$( \
                scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
                    | tr ',' '\n' \
                    | sort -u \
                    | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
            )" && \
            apk add --virtual .python-rundeps $runDeps && \
            apk del .build-deps && \
            find /usr/local -depth \
             \( \
                 \( -type d -a \( -name test -o -name tests \) \) \
                 -o \
                 \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
             \) -exec rm -rf '{}' + && \
            rm -rf /usr/src/python

ENV         PYTHON_PIP_VERSION=9.0.1 \
            PIP_MIRROR=pypi.tuna.tsinghua.edu.cn/simple

RUN         set -ex; \
            apk add --no-cache --virtual .fetch-deps openssl; \
            wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
            apk del .fetch-deps; \
            pipconf=~/.pip/pip.conf && \
            mkdir -p $(dirname $pipconf) && \
            echo "[global]" > $pipconf && \
            echo "index-url = https://$PIP_MIRROR" >> $pipconf && \
            python get-pip.py \
                --disable-pip-version-check \
                --no-cache-dir \
                "pip==$PYTHON_PIP_VERSION" ; \
            pip --version; \
            find /usr/local -depth \
                \( \
                    \( -type d -a \( -name test -o -name tests \) \) \
                    -o \
                    \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
                \) -exec rm -rf '{}' +; \
            rm -f get-pip.py

CMD         ["python2"]
