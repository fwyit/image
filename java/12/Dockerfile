FROM    fwyit/alpine:cn

ENV     JAVA_VERSION=12 \
        JAVA_UPDATE=0 \
        JAVA_BUILD=1 \
        JAVA_HOME="/usr/lib/jvm" \
        JAVA_SID="69cfe15208a647278a19ef0990eea691" \
        PATH=$PATH:/usr/lib/jvm/bin:/usr/lib/jvm/jre/bin


RUN     ver="${JAVA_VERSION}.${JAVA_UPDATE}.${JAVA_BUILD}" && \
        app=jdk-${ver}_linux-x64_bin.tar.gz && \
        cd /tmp/ && \
        url="https://download.oracle.com/otn-pub/java/jdk/$ver+${JAVA_VERSION}/$JAVA_SID/$app" && \
        echo $url && \
        wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" $url && \
        tar -zxvf $app && \
        mkdir -p $JAVA_HOME && \
        mv jdk-${ver}/* $JAVA_HOME/ && \
        rm -rf /tmp/* /root/*
