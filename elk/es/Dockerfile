FROM        java:8u111

ENV         GPG_KEY=46095ACC8548582C1A2699A9D27D666CD88E42B4 \
            PATH=/opt/elasticsearch/bin:$PATH \
            ES_HOME=/opt/elasticsearch \
            ES_USER=elasticsearch \
            ES_VERSION=5.6.9 \
            ES_SHA1=9dae4794cad7b804bffe09d03c94ab25b3e9c586

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
            curl -o /tmp/$app.tar.gz    $repo/elasticsearch/$app.tar.gz && \
            echo "$ES_SHA1  /tmp/$app.tar.gz" | sha1sum -c && \
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
