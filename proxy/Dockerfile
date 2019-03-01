FROM    fwyit/alpine:cn

RUN     repo ali && \
        apk update && \

        apk add --no-cache \
            nodejs && \
        apk add --no-cache -t deps \
            nodejs-npm && \
        npmCN=https://registry.npm.taobao.org && \
        npm config set registry $npmCN && \
        npm i -g anyproxy && \
        adduser -D node && \
        certPath=/home/node/.anyproxy/certificates && \
        mkdir -p $certPath && \
        chown -R node:node $(dirname $certPath) && \
        repo re && \
        apk del deps && \
        rm -rf /tmp/* /root/.npm/_cacache

USER    node
VOLUME  /home/node/.anyproxy/certificates

ENTRYPOINT  /usr/bin/anyproxy -i

