FROM        fwyit/java:8u111

ENV         PATH=/opt/kibana/bin:$PATH \
            KB_HOME=/opt/kibana \
            KB_USER=kibana \
            KB_VERSION=6.5.4

RUN         addgroup -S $KB_USER && \
            adduser -S -G $KB_USER $KB_USER && \
            apk add --no-cache \
                'su-exec>=0.2' && \
            set -ex && \
            apk add --no-cache --virtual .deps \
                ca-certificates \
                openssl \
                curl \
                tar && \
            repo="https://artifacts.elastic.co/downloads" && \
            app="kibana-${KB_VERSION}-linux-x86_64" && \
            cd /tmp && \
            curl -Lo $app.tar.gz $repo/kibana/$app.tar.gz && \
            curl -Lo $app.sha $repo/kibana/$app.tar.gz.sha512 && \
            tar -zxf /tmp/$app.tar.gz -C $(dirname $KB_HOME) && \
            mv $(dirname $KB_HOME)/$app $KB_HOME && \
            apk del .deps && \
            rm -rf /var/cache/apk/* /tmp/*

WORKDIR     $KB_HOME
ADD         config  $KB_HOME/config
VOLUME      $KB_HOME/data

COPY        ./docker-entrypoint.sh /usr/bin/elk

EXPOSE      80

ENTRYPOINT  ["elk"]
CMD         ["kibana", "-c", "config/kibana.yml"]
