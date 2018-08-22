#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来初始化sonar

# sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false
# sonar.jdbc.url=jdbc:oracle:thin:@localhost:1521/XE
# sonar.jdbc.url=jdbc:postgresql://localhost/sonar
# sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar;integratedSecurity=true
# sonar.jdbc.url=jdbc:sqlserver://localhost;databaseName=sonar
SONAR_HOME=${SONAR_HOME:=$SONARQUBE_HOME}
SONAR_USER=${SONAR_USER:=$SONARQUBE_JDBC_USERNAME}
SONAR_PASS=${SONAR_PASS:=$SONARQUBE_JDBC_PASSWORD}

SONAR_HOME=${SONAR_HOME:=/opt/sonarqube}
SONAR_USER=${SONAR_USER:=sonar}
SONAR_PASS=${SONAR_PASS:=Passw0rd}

JDK_MEM=${JDK_MEM:=512m}
jdk_num=$(echo $JDK_MEM | sed 's/\D//g')
jdk_unit=$(echo $JDK_MEM | sed 's/\d//g')
JDK_MAX=$JDK_MEM
JDK_MIN=$((jdk_num/2))$jdk_unit

test -d /default && cp -rf /default/ $SONAR_HOME
conf=$SONAR_HOME/conf/sonar.properties
test "$SONAR_DBURL" && echo "sonar.jdbc.url=$SONAR_DBURL" > $conf || echo "sonar.embeddedDatabase.port=${SONAR_DBPORT:=9092}" > $conf

cat >> $conf <<EOF
sonar.jdbc.username=$SONAR_USER
sonar.jdbc.password=$SONAR_PASS
sonar.jdbc.maxActive=${SONAR_DB_MAX_CONN:=60}
sonar.jdbc.maxIdle=${SONAR_DB_MAX_IDLE:=5}
sonar.jdbc.minIdle=${SONAR_DB_MIN_IDLE:=2}
sonar.jdbc.maxWait=${SONAR_DB_MAX_WAITE:=5000}
sonar.jdbc.minEvictableIdleTimeMillis=600000
sonar.jdbc.timeBetweenEvictionRunsMillis=30000
sonar.web.javaOpts=-Xmx$JDK_MAX -Xms$JDK_MIN -XX:+HeapDumpOnOutOfMemoryError
sonar.web.javaAdditionalOpts=
sonar.web.host=0.0.0.0
sonar.web.context=
sonar.web.port=${SONAR_PORT:=9000}
sonar.web.http.maxThreads=50
sonar.web.http.minThreads=5
sonar.web.http.acceptCount=25
sonar.auth.jwtBase64Hs256Secret=${SONAR_SECRET}
sonar.web.sessionTimeoutInMinutes=4320
sonar.web.systemPasscode=
sonar.web.sso.enable=false
sonar.web.sso.loginHeader=X-Forwarded-Login
sonar.web.sso.nameHeader=X-Forwarded-Name
sonar.web.sso.emailHeader=X-Forwarded-Email
sonar.web.sso.groupsHeader=X-Forwarded-Groups
sonar.web.sso.refreshIntervalInMinutes=5
sonar.ce.javaOpts=-Xmx$JDK_MAX -Xms$JDK_MIN -XX:+HeapDumpOnOutOfMemoryError
sonar.ce.javaAdditionalOpts=
sonar.search.javaOpts=-Xmx$JDK_MAX -Xms$JDK_MIN -XX:+HeapDumpOnOutOfMemoryError
sonar.search.javaAdditionalOpts=
sonar.search.port=9001
sonar.search.host=
sonar.updatecenter.activate=true
sonar.log.level=INFO
sonar.log.level.app=INFO
sonar.log.level.web=INFO
sonar.log.level.ce=INFO
sonar.log.level.es=INFO
sonar.path.logs=logs
sonar.log.rollingPolicy=time:yyyy-MM-dd
sonar.log.maxFiles=7
sonar.web.accessLogs.enable=true
sonar.web.accessLogs.pattern=%i{X-Forwarded-For} %l %u [%t] "%r" %s %b "%i{Referer}" "%i{User-Agent}" "%reqAttribute{ID}"
sonar.web.accessLogs.pattern=%h %l %u [%t] "%r" %s %b "%i{Referer}" "%i{User-Agent}" "%reqAttribute{ID}"
sonar.notifications.delay=60
sonar.path.data=data
sonar.path.temp=temp
sonar.telemetry.enable=true
sonar.search.httpPort=-1
EOF

test -d /config && cp -rf /config/* $SONAR_HOME/conf/

set -e
cd $SONAR_HOME
if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

WEB_JVM_OPTS="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom"
echo "JAVA_OPTS ===> $JAVA_OPTS $WEB_JVM_OPTS"

chown -R sonarqube:sonarqube $SONAR_HOME
exec su-exec sonarqube \
  java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONAR_USER" \
  -Dsonar.jdbc.password="$SONAR_PASS" \
  -Dsonar.jdbc.url="$SONAR_DBURL" \
  -Dsonar.web.javaAdditionalOpts="$WEB_JVM_OPTS" "$@"