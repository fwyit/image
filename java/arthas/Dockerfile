FROM    fwyit/java:8

ENV     ARTHAS_VER=3.1.0

RUN     root=~/.arthas/lib && \
        mkdir -p $root && \
        cd /tmp && \
        app=arthas-packaging-$ARTHAS_VER-bin.zip && \
        wget https://maven.aliyun.com/repository/public/com/taobao/arthas/arthas-packaging/$ARTHAS_VER/$app && \
        unzip $app -d $root && \
        rm -rf /tmp/*

ADD     init.sh /usr/local/bin/debug