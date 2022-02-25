FROM centos:centos7
 
#docker-compose.yml的构建参数
#ARG STIBEL_TAR_NAME

#安装所需软件,拷贝mysql库内容
RUN yum -y install mysql-devel openssl-devel libnsl
RUN cp -r /usr/lib64/mysql/* /usr/lib/

#创建文件目录,拷贝源文件
RUN mkdir -p /home/StiBel
#ADD $STIBEL_TAR_NAME /home/StiBel
ADD StiBel_Prj.tar.gz /home/StiBel
ADD libstdc++.so.6.0.26 /lib64
ADD mysql.yml /home/StiBel/conf
RUN cp -rf /home/StiBel/conf/etc/ld.so.conf.d/mylib.conf /etc/ld.so.conf.d/

#更换libstdc++.so.6链接对象
ADD libstdc++.so.6.0.26 /lib64
RUN rm -rf /lib64/libstdc++.so.6.0.19
RUN rm -rf /lib64/libstdc++.so.6
RUN cd /lib64 && ln -sf ./libstdc++.so.6.0.26 ./libstdc++.so.6

#添加环境变量到 /etc/profile
RUN echo 'ldconfig'  >> /etc/profile

#source 使得环境变量生效
RUN source /etc/profile

#解决重启配置不生效（source /etc/profile）
RUN echo 'source /etc/profile'   >> ~/.bashrc

#设置容器启动时执行的命令
CMD ["bash","-c","tail -f /dev/null"]