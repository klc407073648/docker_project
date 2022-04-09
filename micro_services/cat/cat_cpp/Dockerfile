#基础镜像
FROM klc407073648/centos_build_lib:v3.0

# 安装工具
RUN yum install -y zip unzip dos2unix

# 构建工程路径
RUN mkdir -p /home/cat/mycat-client \
    &&  cd /home/cat/mycat-client   \
    &&  mkdir -p {include/cat,libs,src} \
    &&  mkdir -p /data/appdatas/cat/

# 拷贝源文件
COPY ./environment/package/cat-master.zip           /home
COPY ./environment/src/main.cpp                     /home/cat/mycat-client/src
COPY ./environment/src/Makefile                     /home/cat/mycat-client/src
COPY ./environment/shell/build.sh                   /home/
COPY ./environment/data/appdatas/cat/client.xml     /data/appdatas/cat/

# 设置环境变量
RUN echo "export LD_LIBRARY_PATH=/home/cat/mycat-client/libs" >> /etc/profile \
    && echo 'export CC=/usr/local/bin/gcc'    >> /etc/profile \
    && echo 'export CC=/usr/local/bin/gcc'    >> /etc/profile \
    && echo 'export CXX=/usr/local/bin/g++'   >> /etc/profile \
    && echo 'ldconfig'  >> /etc/profile \
    && echo 'source /etc/profile'  >> ~/.bashrc \
    && source /etc/profile

# 构建cat_cpp
RUN cd /home/  \
    && dos2unix *.sh  \
    && chmod 777 *.sh \
    && ./build.sh