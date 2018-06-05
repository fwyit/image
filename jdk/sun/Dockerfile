FROM        alpine:cn
MAINTAINER  Jam < ops@doat.cc > 

ENV         JAVA_VERSION=8u111 \
            JAVA_VERSION_MAJOR=8 \
            JAVA_VERSION_MINOR=111 \
            JAVA_VERSION_BUILD=14 \
            JAVA_PACKAGE=jdk \
            JAVA_JCE=unlimited \
            JAVA_HOME=/usr/lib/jvm/jdk1.8.0_111 \
            PATH=$PATH:usr/lib/jvm/jdk1.8.0_111/bin

RUN         apk update && \
            apk add --no-cache --virtual .deps \
                bash \
                curl \
                gzip \
                libstdc++ && \
            ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
            echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
            /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
            mkdir -p $(dirname $JAVA_HOME) && \
            curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
                -o /tmp/java.tar.gz \
                http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
            JAVA_PACKAGE_SHA256=$(\
                curl -sSL https://www.oracle.com/webfolder/s/digest/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}checksum.html | \
                grep -E "${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64\.tar\.gz" | \
                grep -Eo '(sha256: )[^<]+' | cut -d: -f2 | xargs) && \
            echo "${JAVA_PACKAGE_SHA256}  /tmp/java.tar.gz" > /tmp/java.tar.gz.sha256 && \
            sha256sum -c /tmp/java.tar.gz.sha256 && \
            gunzip /tmp/java.tar.gz && \
            tar -xf /tmp/java.tar -C $JAVA_HOME && \
            if [ "${JAVA_JCE}" == "unlimited" ]; then echo "Installing Unlimited JCE policy" >&2 && \
                curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
                    -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
                    http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
                unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip -d /tmp && \
                cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar $JAVA_HOME/jre/lib/security; \
            fi && \
            sed -i "s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/" $JAVA_HOME/jre/lib/security/java.security && \
            rm -rf \
                ${JAVA_HOME}/*src.zip \
                ${JAVA_HOME}/lib/missioncontrol \
                ${JAVA_HOME}/lib/visualvm \
                ${JAVA_HOME}/lib/*javafx* \
                ${JAVA_HOME}/jre/plugin \
                ${JAVA_HOME}/jre/bin/javaws \
                ${JAVA_HOME}/jre/bin/jjs \
                ${JAVA_HOME}/jre/bin/orbd \
                ${JAVA_HOME}/jre/bin/pack200 \
                ${JAVA_HOME}/jre/bin/policytool \
                ${JAVA_HOME}/jre/bin/rmid \
                ${JAVA_HOME}/jre/bin/rmiregistry \
                ${JAVA_HOME}/jre/bin/servertool \
                ${JAVA_HOME}/jre/bin/tnameserv \
                ${JAVA_HOME}/jre/bin/unpack200 \
                ${JAVA_HOME}/jre/lib/javaws.jar \
                ${JAVA_HOME}/jre/lib/deploy* \
                ${JAVA_HOME}/jre/lib/desktop \
                ${JAVA_HOME}/jre/lib/*javafx* \
                ${JAVA_HOME}/jre/lib/*jfx* \
                ${JAVA_HOME}/jre/lib/amd64/libdecora_sse.so \
                ${JAVA_HOME}/jre/lib/amd64/libprism_*.so \
                ${JAVA_HOME}/jre/lib/amd64/libfxplugins.so \
                ${JAVA_HOME}/jre/lib/amd64/libglass.so \
                ${JAVA_HOME}/jre/lib/amd64/libgstreamer-lite.so \
                ${JAVA_HOME}/jre/lib/amd64/libjavafx*.so \
                ${JAVA_HOME}/jre/lib/amd64/libjfx*.so \
                ${JAVA_HOME}/jre/lib/ext/jfxrt.jar \
                ${JAVA_HOME}/jre/lib/ext/nashorn.jar \
                ${JAVA_HOME}/jre/lib/oblique-fonts \
                ${JAVA_HOME}/jre/lib/plugin.jar \
                && \
            echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
            apk del .deps && \
            rm -rf /tmp/* /var/cache/apk/*

