FROM    node:8-alpine

RUN     NPM_CN=https://registry.npm.taobao.org/ && \
        npm config set registry $NPM_CN && \
        yarn config set registry $NPM_CN && \
        cd /usr/local/lib/node_modules && \
        npm install --registry=https://registry.npm.taobao.org/ nbnpm && \
        rm -rf core* && \
        export PATH=\$PATH:`pwd`/node_modules/.bin/ && \
        rm -rf /root/.npm/ /tmp/*

ADD     init.sh /usr/bin/node.sh
WORKDIR /project
ENTRYPOINT  ["node.sh"]
CMD     ["nbnpm"]
