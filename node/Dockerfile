FROM    fwyit/alpine:cn

RUN     repo ali && \
        apk update && \
        apk add --no-cache \
            nodejs-npm \
            yarn \
            && \
        repo reset && \
        rm -rf /root/cache/* /tmp/*

RUN     NPM_CN=https://registry.npm.taobao.org/ && \
        npm config set registry $NPM_CN && \
        yarn config set registry $NPM_CN && \
        npm install -g --registry=https://registry.npm.taobao.org/ nbnpm && \
        rm -rf /root/.npm/ /tmp/*

ADD     init.sh /usr/bin/node.sh
WORKDIR /project
ENTRYPOINT  ["node.sh"]
CMD     ["nbnpm"]
