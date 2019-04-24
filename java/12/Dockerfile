FROM    fwyit/alpine:cn

ENV     JAVA_VERSION=12 \
        JAVA_UPDATE=0 \
        JAVA_BUILD=1 \
        JAVA_HOME="/usr/lib/jvm" \
        JAVA_SID="69cfe15208a647278a19ef0990eea691" \
        PATH=$PATH:/usr/lib/jvm/bin:/usr/lib/jvm/jre/bin


RUN     ver="${JAVA_VERSION}.${JAVA_UPDATE}.${JAVA_BUILD}" && \
        app=jdk-$ver_linux-x64_bin.tar.gz && \
        cd /tmp/ && \
        wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
            "https://download.oracle.com/otn-pub/java/jdk/$ver+${JAVA_VERSION}/$JAVA_SID/$app" && \
        tar -zxvf $app && \
        mkdir -p $JAVA_HOME && \
        mv jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}/* $JAVA_HOME/ && \
        rm -rf /tmp/* /root/*
