#!/usr/bin/env sh
#author      : Jam < liujianhncn@gmail.com >
#version     : 1.0
#description : 本脚本主要用来启动splunk-forwardserver

LOG_PATH=$SPLUNK_HOME/var/log/splunk
LAUNCH_CONF=$SPLUNK_HOME/etc/splunk-launch.conf
SPT_FILE=$(dirname $SPLUNK_HOME)/splunk-$SPLUNK_VERSION-Linux-x86_64.tgz
WITH_AUTH="-auth ${SPT_USER:=admin}:${SPT_PASS:=changeme}"
LOCAL_CONF=$SPLUNK_HOME/etc/system/local
LOCAL_CONF_ZIP=/tmp/local.conf.tgz
LOCALS="apps/splunk_instrumentation apps/splunk_httpinput apps/search apps/learned master-apps/_cluster users/admin/user-prefs users/admin/search"

echo "当前用户: $WITH_AUTH"


# if test "$(ls $LOCAL_CONF | wc -l)" -gt 1; then
#     echo "准备备份原有本地配置文件..."
#     cd $LOCAL_CONF
#     tar -zcvf $LOCAL_CONF_ZIP *
# fi

_link(){
    f=$(find /usr -name $1* | head -n 1)
    test "$f" && n="$(dirname $f)/$1.so.1.0.0"
    test "$n" && test "$f" != "$n" && ln -sf $f $n
}

echo "准备安装splunk-server，请耐心等待..."
MANIFEST=$SPLUNK_HOME/splunk-$SPLUNK_VERSION-linux-2.6-x86_64-manifest
test -e $SPT_FILE && test ! -e $MANIFEST && tar -zxf $SPT_FILE -C $(dirname $SPLUNK_HOME)
# test -e $LOCAL_CONF_ZIP && tar -zxvf $LOCAL_CONF_ZIP -C $LOCAL_CONF

# 准备分发本地配置文件
#test ! -h $LOCAL_CONF && mv ${LOCAL_CONF}{,.bak} && ln -sf $SPLUNK_HOME/local/system/ $LOCAL_CONF
# test ! -h $LOCAL_CONF && mv ${LOCAL_CONF} /tmp/ && ln -sf $SPLUNK_HOME/local/system/ $LOCAL_CONF
# 由于$LOCAL_CONF启动的过程中资源被占用 不能直接进行文件移动，需要将原有的配置文件同步至配置文件中
localConf=$SPLUNK_HOME/local/system
mkdir -p $localConf
localCount=$(ls $localConf | wc -l)
originCount=$(ls $LOCAL_CONF | wc -l)
test $originCount -gt $localCount && cp -rf $LOCAL_CONF/* $localConf || cp -rf $localConf/* $LOCAL_CONF

for l in $LOCALS; do
    base=$(basename $l)
    src="$SPLUNK_HOME/local/$base"
    dest="$SPLUNK_HOME/etc/$l/local"
    if test -d $src; then
        # cp -rf $src $dest && echo "成功还原本地配置: $src ---> $dest"
        test -d $dest || mkdir -p $dest
        mv $dest ${dest}.bak && ln -sf $src $dest && echo "成功还原本地配置: $src ---> $dest"
    else
        test -d $dest && mv $dest $src && ln -sf $src $dest || echo "未找到$dest..."
    fi
done

echo "准备创建软链..."
_link libssl
_link libcrypto

test -e $LAUNCH_CONF && cat $LAUNCH_CONF && . $LAUNCH_CONF
test "$OPTIMISTIC_ABOUT_FILE_LOCKING" || echo "OPTIMISTIC_ABOUT_FILE_LOCKING=1" >> $LAUNCH_CONF
cat $LAUNCH_CONF

echo "准备清理配置文件中的密码信息..."
serverConf=$SPLUNK_HOME/etc/system/local/server.conf
test -e $serverConf && sed -i -e '/pass4SymmKey/d' -e '/sslPassword/d' $serverConf

AUTH_CONF=$SPLUNK_HOME/etc/system/local/authentication.conf
test -e $AUTH_CONF && test "$LDAP_PASSWD" && sed -i "s@bindDNpassword.*@bindDNpassword = $LDAP_PASSWD@" $AUTH_CONF && cat $AUTH_CONF

test "$(ps -ef | grep splunk | grep -v grep)" && echo "splunk服务已经启动，准备退出..." && exit

test -e "etc/passwd" && mv etc/passwd etc/passwd.$(date +%s)
test "$SPT_PASS" && SPT_OPTION="--seed-passwd $SPT_PASS" || SPT_OPTION="--gen-and-print-passwd"
splunk start --accept-license --answer-yes $SPT_OPTION
echo "成功启动..."
# splunk restart

echo "准备挂载当前当前系统的转发日志...."
LOG_DATA=${LOG_DATA:=/data}
if test -d $LOG_DATA; then
    for name in `ls $LOG_DATA | grep log$`; do
        fileName=$LOG_DATA/$name
        echo "准备添加 $fileName"
        splunk add monitor $fileName $WITH_AUTH && echo "成功新增$fileName..."
    done
fi
splunk list monitor $WITH_AUTH & 2>&1

echo "准备放开监听端口..."
splunk enable listen 9997 $WITH_AUTH 

tail -f $LOG_PATH/splunkd-utility.log