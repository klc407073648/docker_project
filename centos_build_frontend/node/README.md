# centos_build_frontend

## 镜像初始构建

## 改用centos镜像，添加maven和jdk解决

```dockerfile
FROM centos:7

# 安装nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
RUN yum install -y nodejs

# 全局安装yarn并配置淘宝源
RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN yum install -y yarn
RUN yarn config set registry http://registry.npm.taobao.org/

# 安装vite
#npm install vite -g
#yarn global add vite

# 安装umi
#yarn global add umi
```

## 构建过程

```
docker build -f ./Dockerfile -t docker.io/klc407073648/centos_build_frontend:v1.0 .
docker run -it -d -v /home/stibel/prj/:/home/stibel/prj/ --name centos_build_frontend_0 docker.io/klc407073648/centos_build_frontend:v1.0 /bin/bash

#push到docker hub,需要事先docker login 登陆账号
docker push docker.io/klc407073648/centos_build_frontend:v1.0
```

```
[root@VM-16-6-centos build_jdk]# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: klc407073648
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

## 运行容器，测试构建

```bash
docker run -it -d -v /home/stibel/prj/:/home/stibel/prj/ --name centos_build_frontend_0 docker.io/klc407073648/centos_build_frontend:v1.0 /bin/bash
docker exec -it centos_build_frontend_0 bash

# 测试构建
cd /home/stibel/prj/userCenter/frontend
yarn install -y && yarn global add vite && vite build
```
