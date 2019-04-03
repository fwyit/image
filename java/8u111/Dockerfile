FROM    fwyit/alpine:cn

ENV     JAVA_VERSION=8 \
        JAVA_UPDATE=201 \
        JAVA_BUILD=09 \
        JAVA_HOME="/usr/lib/jvm" \
        JAVA_SID="42970487e3af4f5aa5bca3f542482c60" \
        PATH=$PATH:/usr/lib/jvm/bin:/usr/lib/jvm/jre/bin


RUN     ver="${JAVA_VERSION}u${JAVA_UPDATE}" && \
        app=server-jre-$ver-linux-x64.tar.gz && \
        cd /tmp/ && \
        wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
            "https://download.oracle.com/otn-pub/java/jdk/$ver-b${JAVA_BUILD}/$JAVA_SID/$app" && \
        tar -zxf $app && \
        mv jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}/* $JAVA_HOME/ && \
        rm -rf /tmp/* /root/*
