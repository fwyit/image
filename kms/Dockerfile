FROM        fwyit/alpine:cn

ENV         WORKDIR=/opt/kms

RUN         repo ali && apk update && \
            apk add --no-cache \
                ca-certificates \
                python \
                && \
            tmp=/tmp/pykms.zip && \
            wget https://github.com/SystemRage/py-kms/archive/master.zip -O $tmp && \
            cd $(dirname $tmp) && \
            unzip $tmp && \
            opt=$WORKDIR && \
            mkdir -p $opt && \
            mv py-kms-master/py2-kms/* $opt && \
            rm -rf /tmp/* /var/cache/apk/*

WORKDIR     $WORKDIR

ADD         init.sh /usr/local/bin/kms

ENTRYPOINT  ["kms"]