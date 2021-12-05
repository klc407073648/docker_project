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