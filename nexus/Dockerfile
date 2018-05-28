FROM        alpine:jdk_8u111

ENV         NEXUS_VER=3.11.0-01 \
            NEXUS_HOME=/data

ADD         ./nexus-3.11.0-01-unix.tar.gz /opt

RUN         mkdir -p /data/ && \
            adduser -D -h /data nexus && \
            chown -R nexus:nexus \
                data/ \
                /opt/nexus-$NEXUS_VER \
                /opt/sonatype-work

ADD         ./init.sh /usr/bin/nexus
CMD         nexus