# Docker部署

https://blog.csdn.net/wujun2412/article/details/106761958/

## Apollo Config Service

### 获取镜像

```bash

docker pull apolloconfig/apollo-configservice:${version}

```

### 运行镜像

示例：

```bash

docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://fill-in-the-correct-server:3306/ApolloConfigDB?characterEncoding=utf8" \
  -e SPRING_DATASOURCE_USERNAME=FillInCorrectUser -e SPRING_DATASOURCE_PASSWORD=FillInCorrectPassword \
  -d -v /tmp/logs:/opt/logs --name apollo-configservice apolloconfig/apollo-configservice:${version}
```

参数说明：

* SPRING_DATASOURCE_URL: 对应环境ApolloConfigDB的地址

* SPRING_DATASOURCE_USERNAME: 对应环境ApolloConfigDB的用户名

* SPRING_DATASOURCE_PASSWORD: 对应环境ApolloConfigDB的密码

## Apollo Admin Service

### 获取镜像

```bash

docker pull apolloconfig/apollo-adminservice:${version}

```

### 运行镜像

示例：

```bash

docker run -p 8090:8090 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://fill-in-the-correct-server:3306/ApolloConfigDB?characterEncoding=utf8" \
  -e SPRING_DATASOURCE_USERNAME=FillInCorrectUser -e SPRING_DATASOURCE_PASSWORD=FillInCorrectPassword \
  -d -v /tmp/logs:/opt/logs --name apollo-adminservice apolloconfig/apollo-adminservice:${version}
```

参数说明：

* SPRING_DATASOURCE_URL: 对应环境ApolloConfigDB的地址

* SPRING_DATASOURCE_USERNAME: 对应环境ApolloConfigDB的用户名

* SPRING_DATASOURCE_PASSWORD: 对应环境ApolloConfigDB的密码

### Apollo Portal

### 获取镜像

```bash

docker pull apolloconfig/apollo-portal:${version}

```

### 运行镜像

示例：

```bash

docker run -p 8070:8070 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://fill-in-the-correct-server:3306/ApolloPortalDB?characterEncoding=utf8" \
  -e SPRING_DATASOURCE_USERNAME=FillInCorrectUser -e SPRING_DATASOURCE_PASSWORD=FillInCorrectPassword \
  -e APOLLO_PORTAL_ENVS=dev,pro \
  -e DEV_META=http://fill-in-dev-meta-server:8080 -e PRO_META=http://fill-in-pro-meta-server:8080 \
  -d -v /tmp/logs:/opt/logs --name apollo-portal apolloconfig/apollo-portal:${version}
```

参数说明：

* SPRING_DATASOURCE_URL: 对应环境ApolloPortalDB的地址
* SPRING_DATASOURCE_USERNAME: 对应环境ApolloPortalDB的用户名
* SPRING_DATASOURCE_PASSWORD: 对应环境ApolloPortalDB的密码
* APOLLO_PORTAL_ENVS(可选): 对应ApolloPortalDB中的[apollo.portal.envs](#_311-apolloportalenvs-可支持的环境列表)配置项，如果没有在数据库中配置的话，可以通过此环境参数配置
* DEV_META/PRO_META(可选): 配置对应环境的Meta Service地址，以${ENV}_META命名，需要注意的是如果配置了ApolloPortalDB中的[apollo.portal.meta.servers](#_312-apolloportalmetaservers-各环境meta-service列表)配置，则以apollo.portal.meta.servers中的配置为准

## 构建示例

apollo的构建脚本如下，1.1.1.1为虚机的ip：

```
docker run -p 8080:8080 \
    -e SPRING_DATASOURCE_URL="jdbc:mysql://1.1.1.1:3307/ApolloConfigDB?characterEncoding=utf8" \
    -e SPRING_DATASOURCE_USERNAME=root -e SPRING_DATASOURCE_PASSWORD=456789 \
    -d -v /tmp/logs:/opt/logs --name apollo-configservice apolloconfig/apollo-configservice:1.9.2

docker run -p 8090:8090 \
    -e SPRING_DATASOURCE_URL="jdbc:mysql://1.1.1.1:3307/ApolloConfigDB?characterEncoding=utf8" \
    -e SPRING_DATASOURCE_USERNAME=root -e SPRING_DATASOURCE_PASSWORD=456789 \
    -d -v /tmp/logs:/opt/logs --name apollo-adminservice apolloconfig/apollo-adminservice:1.9.2
    
docker run -p 8070:8070 \
    -e SPRING_DATASOURCE_URL="jdbc:mysql://139.196.82.84:3307/ApolloPortalDB?characterEncoding=utf8" \
    -e SPRING_DATASOURCE_USERNAME=root -e SPRING_DATASOURCE_PASSWORD=456789 \
    -e APOLLO_PORTAL_ENVS=dev \
    -e DEV_META=http://1.1.1.1:8080 \
    -d -v /tmp/logs:/opt/logs --name apollo-portal apolloconfig/apollo-portal:1.9.2
```

运行结果如下：

```
[root@iZuf61kbf845xt6tz10abgZ scripts]# docker ps -a
CONTAINER ID        IMAGE                                     COMMAND                  CREATED             STATUS                PORTS                                                                NAMES
f07ee3c50d6c        apolloconfig/apollo-portal:1.9.2          "/apollo-portal/sc..."   26 seconds ago      Up 25 seconds         0.0.0.0:8070->8070/tcp                                               apollo-portal
8bdf7e416422        apolloconfig/apollo-adminservice:1.9.2    "/apollo-adminserv..."   2 minutes ago       Up 2 minutes          0.0.0.0:8090->8090/tcp                                               apollo-adminservice
1db9f8b2affa        apolloconfig/apollo-configservice:1.9.2   "/apollo-configser..."   11 minutes ago      Up 11 minutes         0.0.0.0:8080->8080/tcp   
```

## 通过源码构建 Docker 镜像

如果修改了 apollo 服务端的代码，希望通过源码构建 Docker 镜像，可以参考下面的步骤：

1. 通过源码构建安装包：`./scripts/build.sh`

2. 构建 Docker 镜像：`mvn docker:build -pl apollo-configservice,apollo-adminservice,apollo-portal`

### 之前的版本

Apollo项目已经自带了Docker file，可以参照[2.2.1 获取安装包](#_221-获取安装包)配置好安装包后通过下面的文件来打Docker镜像：

1. [apollo-configservice](https://github.com/ctripcorp/apollo/blob/master/apollo-configservice/src/main/docker/Dockerfile)

2. [apollo-adminservice](https://github.com/ctripcorp/apollo/blob/master/apollo-adminservice/src/main/docker/Dockerfile)

3. [apollo-portal](https://github.com/ctripcorp/apollo/blob/master/apollo-portal/src/main/docker/Dockerfile)

也可以参考Apollo用户[@kulovecc](https://github.com/kulovecc)的[docker-apollo](https://github.com/kulovecc/docker-apollo)项目和[@idoop](https://github.com/idoop)的[docker-apollo](https://github.com/idoop/docker-apollo)项目。
