 #!/bin/bash

: ${APP_PORT:=8080}
: ${APP_ARGS:=""}

service mysql start > /dev/null

# 等待 MySQL 启动成功
until mysqladmin ping -h 127.0.0.1 -P 3306 --silent; do
    echo "Waiting for MySQL to start..."
    sleep 2
done

# 执行 Java 程序
API_ARGS="--server.port=${APP_PORT}"
java -Djava.security.egd=file:/dev/./urandom -jar /opt/api/spider-flow.jar $API_ARGS $APP_ARGS