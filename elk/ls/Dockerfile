FROM        fwyit/java:8u111

ENV         PATH=/opt/logstash/bin:$PATH \
            LS_HOME=/opt/logstash \
            LS_USER=logstash \
            LS_VERSION=6.5.4

RUN         addgroup -S $LS_USER && \
            adduser -S -G $LS_USER $LS_USER && \
            apk add --no-cache \
                'su-exec>=0.2' && \
            set -ex && \
            apk add --no-cache --virtual .deps \
                ca-certificates \
                openssl \
                curl \
                tar && \
            repo="https://artifacts.elastic.co/downloads" && \
            app="logstash-${LS_VERSION}" && \
            cd /tmp && \
            curl -Lo $app.tar.gz $repo/logstash/$app.tar.gz && \
            curl -Lo $app.sha $repo/logstash/$app.tar.gz.sha512 && \
            cat $app.sha | sha512sum -c && \
            tar -zxf /tmp/$app.tar.gz -C $(dirname $LS_HOME) && \
            mv $(dirname $LS_HOME)/logstash-${LS_VERSION} $LS_HOME && \
            apk del .deps && \
            rm -rf /var/cache/apk/* /tmp/*

WORKDIR     $LS_HOME
ADD         config  $LS_HOME/config
VOLUME      $LS_HOME/data

COPY        ./docker-entrypoint.sh /usr/bin/elk.sh

EXPOSE      9200 9300

ENTRYPOINT  ["sh", "/usr/bin/elk.sh"]
CMD         ["kibana"]
