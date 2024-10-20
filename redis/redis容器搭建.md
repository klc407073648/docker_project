# redis容器搭建

## 参考资料

* [docker 创建redis容器以及redis命令笔记 ](https://www.cnblogs.com/jinit/p/13739191.html)


## 制作redis的docker镜像的文件介绍

```
yum install tree

[root@master01 redis]#  tree
.
|-- build_redis.sh          #使用docker build -t docker.io/klc407073648/docker-redis:v1.0 . 制作以Dockerfile文件为基础的镜像
|-- conf
|   |-- redis-6379.conf     # 使用的redis配置文件
|   `-- redis.conf		    # 原始配置文件
|-- Dockerfile


整个构建过程，直接执行./build_redis.sh 即可
```

## 实践

```
[root@VM-0-10-centos Redis]# docker ps -a
CONTAINER ID        IMAGE                                      COMMAND                  CREATED             STATUS              PORTS                               NAMES
b1298edf0d30        docker.io/klc407073648/docker-redis:v1.0   "docker-entrypoint..."   10 minutes ago      Up 10 minutes       0.0.0.0:6380->6379/tcp              docker-redis
2c2b44463303        docker.io/klc407073648/docker-mysql:v1.0   "docker-entrypoint..."   41 minutes ago      Up 41 minutes       33060/tcp, 0.0.0.0:3307->3306/tcp   docker-mysql
80dd79144bf6        elasticsearch:7.12.1                       "/bin/tini -- /usr..."   2 months ago        Up 2 months         0.0.0.0:9200->9200/tcp, 9300/tcp    es01
[root@VM-0-10-centos Redis]# docker exec -it b1298edf0d30 bash
root@b1298edf0d30:/data# redis-cli
127.0.0.1:6379> keys *
(error) NOAUTH Authentication required.

```

解决方法：

1:命令行模式下，auth输入
```
root@b1298edf0d30:/data#  ./redis-cli
127.0.0.1:6379> auth 123456
OK
127.0.0.1:6379> keys *
1) "name"
127.0.0.1:6379> set num 44444
OK
127.0.0.1:6379>
```

2:输入redis-cli时，带指定参数
```
root@b1298edf0d30:/data# 
redis-cli -h 127.0.0.1 -p 6379 -a 123456
```

为现有的redis创建密码或修改密码的方法：
```
#1.进入redis的容器
docker exec -it 容器ID bash

#2.进入redis目录
cd /usr/local/bin

#3.运行命令：
redis-cli

#4.查看现有的redis密码：
config get requirepass

#5.设置redis密码
config set requirepass 密码
```
