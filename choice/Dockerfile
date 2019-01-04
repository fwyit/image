FROM        python:3.6-slim
MAINTAINER  Jam < liujian@mail.com >


RUN         PIP_MIRROR=https://pypi.douban.com/simple \
            DEB_MIRROR=mirrors.aliyun.com && \
            sed -i "s/deb.debian.org/$DEB_MIRROR/g" /etc/apt/sources.list && \
            apt-get update && apt-get install -y unzip && \
            pip install -i $PIP_MIRROR \
                pymongo \
                numpy==1.14.5 \
                pillow \
                pandas \
                apscheduler \
                click==6.7 \
                Flask==1.0.2 \
                itsdangerous==0.24 \
                Jinja2==2.10 \
                MarkupSafe==1.0 \
                Werkzeug==0.14.1 \
                flask_restful \
                flask_restful_swagger \
                flask_script \
                aliyun-python-sdk-dysmsapi==1.0.0 \
                PyMySQL==0.9.2 \
                urllib3==1.23 \
                redis==2.10.6 \
                swagger-py-codegen==0.2.9 \
                Werkzeug==0.14.1 \
                WTForms==2.2.1 \
                && \
            rm -rf /tmp/*

ADD         init.sh /usr/bin/init.sh
WORKDIR     /opt

CMD         init.sh

#ADD         data-engine.zip /app.zip

#ENV         VER=0.0.4 \
#            COMMIT=329ab4c335c95805a7f9c65758bd7cf816aef92b
