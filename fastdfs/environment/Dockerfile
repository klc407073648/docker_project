FROM ubuntu:xenial

# 更新数据源
WORKDIR /etc/apt
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse' > sources.list
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse' >> sources.list
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse' >> sources.list
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse' >> sources.list
RUN apt-get update

# 安装依赖
RUN apt-get install git make gcc libpcre3-dev zlib1g-dev  build-essential --assume-yes

# 复制工具包
ADD nginx-1.15.4.tar.gz /usr/local/src/
ADD libfastcommon-1.0.53.tar.gz /usr/local/src/
ADD fastdfs-6.07.tar.gz /usr/local/src/
ADD fastdfs-nginx-module-1.22.tar.gz /usr/local/src/

RUN mkdir -p /root/fastdfs

RUN mkdir /root/fastdfs/tracker   \
  &&  mkdir /root/fastdfs/storage   \
  &&  cd /usr/local/src/libfastcommon-1.0.53/  \
  &&  ./make.sh && ./make.sh install  \
  &&  cd /usr/local/src/fastdfs-6.07/   \
  &&  ./make.sh && ./make.sh install  \
  &&  cd /usr/local/src/nginx-1.15.4/  \
  &&  ./configure --add-module=/usr/local/src/fastdfs-nginx-module-1.22/src/   \
  &&  make && make install

# 配置 FastDFS 跟踪器
COPY tracker.conf /etc/fdfs

# 配置 FastDFS 存储
COPY storage.conf /etc/fdfs

# 配置 FastDFS 客户端
COPY client.conf /etc/fdfs

COPY mod_fastdfs.conf /etc/fdfs

WORKDIR /usr/local/src/fastdfs-6.07/conf
RUN cp http.conf mime.types /etc/fdfs/

# 配置 Nginx
COPY nginx.conf /usr/local/nginx/conf

# Entrypoint设置在运行容器时将首先执行的命令和参数
COPY entrypoint.sh /usr/local/bin/
RUN   chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]  

WORKDIR /
EXPOSE 8888

CMD ["/bin/bash"]