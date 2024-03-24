FROM ubuntu:20.04

ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV FEATURE_ANALYSIS=""

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata

RUN apt-get install -y fonts-wqy-zenhei language-pack-zh-hans
RUN locale-gen zh_CN.UTF-8 && update-locale LC_ALL=zh_CN.UTF-8 LANG=zh_CN.UTF-8

RUN \
  apt-get install -y \
    openjdk-8-jdk-headless \
    mysql-server

# Install mysql
ADD db/spiderflow.sql /tmp/
RUN /etc/init.d/mysql start \
    && mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456789';" \
    && mysql -u root -p123456789 < /tmp/spiderflow.sql \
    && usermod -d /var/lib/mysql/ mysql \
    && /etc/init.d/mysql stop

RUN rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/api
ADD ./spider-flow-web/target/spider-flow.jar /opt/api/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /opt/api

ENTRYPOINT ["sh", "/entrypoint.sh"]