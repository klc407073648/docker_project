# centos_build_lib 镜像构建

## 镜像初始构建

参考 centos_build_lib 文件夹里面的内容:

1. yum install 必要的包
2. 安装scons,cmake,gcc等内容，其中gcc安装过程很久，需要进入容器操作，[可以参考](./centos_build_lib/build_lib镜像制作.md)

```dockerfile
FROM centos:centos7

#创建路径
RUN mkdir -p /home/tools

RUN echo 'install environment'

RUN yum -y install tar wget gcc gcc-c++ libxml2-devel zlib-devel bzip2-devel bzip2 \
    curl-devel libjpeg-devel libpng-devel libtiff-devel freetype-devel openssl \
    openssl-devel vim ncurses-devel zip unzip

COPY ./package/scons-3.1.1.zip /home/tools
COPY ./package/cmake-3.14.5.tar.gz /home/tools
COPY ./package/gcc-9.1.0.tar.gz /home/tools

RUN cd /home/tools && unzip scons-3.1.1.zip
RUN cd /home/tools/scons-3.1.1 && python setup.py install

RUN cd /home/tools && tar -zxf  cmake-3.14.5.tar.gz
RUN cd /home/tools/cmake-3.14.5 && ./bootstrap && gmake && gmake install && ln -s /usr/local/bin/cmake /usr/bin/

#gcc编译太久，手动进入容器编译
```

## 镜像继续添加内容
参考 Dockerfile文件内容:

1. yum install 必要的包
2. 安装python3.7
3. 解决gcc版本的遗留问题

```dockerfile
#基础镜像
FROM docker.io/klc407073648/centos_build_lib

#安装mysql客户端API
RUN yum install -y mysql-devel git dos2unix

#安装python
#WORKDIR /home/tools
COPY ./Python-3.7.10.tgz /home/tools
RUN cd /home/tools && tar -xvf Python-3.7.10.tgz
RUN mkdir -p /home/tools/python3

RUN cd /home/tools/Python-3.7.10 ./configure --prefix=/home/tools/python3/ --with-ssl
RUN cd /home/tools/Python-3.7.10 && make
RUN cd /home/tools/Python-3.7.10 && make install

RUN ln -s /home/tools/python3/bin/python3.7 /usr/bin/python3
RUN ln -s /home/tools/python3/bin/pip3 /usr/bin/pip3
RUN python3 -m pip install --upgrade pip

#更换libstdc++.so.6链接对象
RUN rm -rf /lib64/libstdc++.so.6.0.19
RUN rm -rf /lib64/libstdc++.so.6
RUN cp -rf /usr/local/lib64/libstdc++.so.6.0.26 /lib64
RUN cd /lib64 && ln -sf ./libstdc++.so.6.0.26 ./libstdc++.so.6

#添加环境变量到 /etc/profile
RUN echo 'export CC=/usr/local/bin/gcc'    >> /etc/profile
RUN echo 'export CXX=/usr/local/bin/g++'   >> /etc/profile
RUN echo 'ldconfig'  >> /etc/profile

#source 使得环境变量生效
RUN source /etc/profile

#解决重启配置不生效（source /etc/profile）
RUN echo 'source /etc/profile'   >> ~/.bashrc
```
## 构建过程

```
#第一版构建完后，centos_build_lib改名成docker.io/klc407073648/centos_build_lib
docker build -t centos_build_lib .
#第二版构建
docker build -f ./Dockerfile -t docker.io/klc407073648/centos_build_lib:v3.0 .


#push到docker hub,需要事先docker login 登陆账号
docker push docker.io/klc407073648/centos_build_lib:v3.0
```
## 运行容器，测试构建第三方库
```bash
docker run -it -d --name centos_build_lib_0 docker.io/klc407073648/centos_build_lib:v3.0 /bin/bash


#进入容器，编译内容
docker exec -it c6ea544e0882 bash

cd /home/tools/
unzip build_lib.zip

cd ./build_lib/build
chmod 777 *.sh
dos2unix  *.sh
./build.sh

#测试编译后的内容
cd /home/tools/examples/deploy/3partlib/yamlcpp
./YamlTest
```
