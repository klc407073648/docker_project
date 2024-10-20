#基础镜像
FROM docker.io/klc407073648/centos_build_lib

#安装mysql客户端API
RUN yum install -y mysql-devel git dos2unix

#安装python
#WORKDIR /home/tools
COPY ./Python-3.7.10.tgz /home/tools
RUN cd /home/tools && tar -xvf Python-3.7.10.tgz
RUN mkdir -p /home/tools/python3

RUN cd /home/tools/Python-3.7.10 && ./configure --prefix=/home/tools/python3/ --with-ssl
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