FROM        fwyit/java:8u111

ENV         PATH=/opt/elasticsearch/bin:$PATH \
            ES_HOME=/opt/elasticsearch \
            ES_USER=elasticsearch \
            ES_VERSION=6.5.4

RUN         addgroup -S $ES_USER && \
            adduser -S -G $ES_USER $ES_USER && \
            apk add --no-cache \
                'su-exec>=0.2' && \
            set -ex && \
            apk add --no-cache --virtual .deps \
                ca-certificates \
                openssl \
                curl \
                tar && \
            repo="https://artifacts.elastic.co/downloads" && \
            app="elasticsearch-${ES_VERSION}" && \
            cd /tmp && \
            curl -Lo $app.tar.gz $repo/elasticsearch/$app.tar.gz && \
            curl -Lo $app.sha $repo/elasticsearch/$app.tar.gz.sha512 && \
            cat $app.sha | sha512sum -c && \
            tar -zxf /tmp/$app.tar.gz -C $(dirname $ES_HOME) && \
            mv $(dirname $ES_HOME)/elasticsearch-${ES_VERSION} $ES_HOME && \
            apk del .deps && \
            rm -rf /va/cache/apk/* /tmp/*

ADD         config  $ES_HOME/config
VOLUME      $ES_HOME/data

COPY        docker-entrypoint.sh /usr/bin/es.sh

EXPOSE      9200 9300

ENTRYPOINT  ["es.sh"]
CMD         ["elasticsearch"]
