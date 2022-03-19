FROM centos:centos7
 
#docker-compose.yml的构建参数
#ARG STIBEL_TAR_NAME

#安装所需软件,拷贝mysql库内容
RUN yum -y install mysql-devel openssl-devel libnsl   \
    &&  cp -r /usr/lib64/mysql/* /usr/lib/

#创建文件目录,拷贝源文件
RUN mkdir -p /home/StiBel
ADD StiBel_Prj.tar.gz /home/StiBel
COPY libstdc++.so.6.0.26 /lib64
COPY mysql.yml /home/StiBel/conf
RUN cp -rf /home/StiBel/conf/etc/ld.so.conf.d/mylib.conf /etc/ld.so.conf.d/

#更换libstdc++.so.6链接对象
COPY libstdc++.so.6.0.26 /lib64
RUN rm -rf /lib64/libstdc++.so.6.0.19   \
    &&  rm -rf /lib64/libstdc++.so.6   \
    &&  cd /lib64 && ln -sf ./libstdc++.so.6.0.26 ./libstdc++.so.6

# 添加环境变量到/etc/profile
# 解决重启配置不生效(source /etc/profile)
# source 使得环境变量生效
RUN echo 'ldconfig'  >> /etc/profile   \
    && echo 'source /etc/profile'   >> ~/.bashrc   \
    && source /etc/profile      

# 设置环境变量
ENV HOME_PATH /home/StiBel   \
    && STIBEL_VERSION V2.1.1      \
    && LIB_VERSION V1.1.0

# 设置容器启动时执行的命令
# tail -f /dev/null 是为了 Docker容器后台运行,就必须有一个前台进程
CMD ["bash","-c","cd /home/StiBel/DockerBuild && ./run.sh && tail -f /dev/null"]