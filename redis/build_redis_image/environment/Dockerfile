#centos作为基础镜像
FROM klc407073648/centos_build_lib:v3.0

#docker-compose.yml的构建参数
ARG REDIS_PORT
ARG REDIS_PASSWORD

#redis安装所需文件
RUN mkdir -p /home/redis/install
ADD ./package/redis-6.2.0.tar.gz    /home/redis/install
ADD ./shell/install_redis.sh        /home/redis/install
ADD ./conf/redis-6379.conf          /home/redis
ADD ./shell/start.sh                /home/redis

#权限
RUN chmod 755 /home/redis/redis-6379.conf
RUN chmod 755 /home/redis/start.sh
RUN chmod 755 /home/redis/install/install_redis.sh

#修改动态参数
RUN sed -i "s/\$REDIS_PORT/$REDIS_PORT/g"                     /home/redis/redis-6379.conf
RUN sed -i "s/\$REDIS_PASSWORD/$REDIS_PASSWORD/g"             /home/redis/redis-6379.conf

#安装redis
RUN /home/redis/install/install_redis.sh

CMD ["/bin/bash","-c","cd /home/redis && ./start.sh"]