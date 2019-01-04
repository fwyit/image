FROM        sonarqube:lts-alpine
MAINTAINER  Jam < ops@doat.cc >

# RUN         sed -i "s@dl-cdn.alpinelinux.org@mirrors.aliyun.com@g" /etc/apk/repositories && \
#             apk update && \
#             apk add --no-cache

COPY        ./default   /default

RUN         cp -rf /default/* $SONARQUBE_HOME/ && \
            rm -rf /default/*

ADD         init.sh /usr/bin/sonar.sh
CMD         ["/usr/bin/sonar.sh"]
