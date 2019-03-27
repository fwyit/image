FROM    fwyit/alpine:cn

ENV     SPLUNK_HOME=/opt/splunk \
        SPLUNK_VERSION=7.2.5-088f49762779 \
        PATH=$PATH:/opt/splunk/bin

RUN     cd /tmp && \
        apk update && \
        apk add --no-cache --update procps && \
        app=splunk-${SPLUNK_VERSION}-Linux-x86_64.tgz && \
        ver=${SPLUNK_VERSION%%-*} && \
        wget -O $app \
            "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=${ver}&product=splunk&filename=$app&wget=true" && \
        base=$(dirname $SPLUNK_HOME) && \
        mkdir -p $base && \
        tar -zxvf $app -C $base && \
        rm -rf /tmp/* /var/cache/apk/*

ADD     init.sh /usr/bin/spt

VOLUME  $SPLUNK_HOME/etc/system/local
WORKDIR $SPLUNK_HOME

EXPOSE  9997 8000
ENTRYPOINT  ['spt']
