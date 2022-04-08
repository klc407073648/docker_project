#基础镜像
FROM centos:centos7

#创建路径
RUN mkdir -p /home/logstash

#安装工具
RUN yum -y install zip unzip wget

#安装java和logstash
ADD ./package/jdk-8u221-linux-x64.tar.gz /usr/local
ADD ./package/logstash-7.1.0.tar.gz /home/logstash

#添加环境变量到 /etc/profile
RUN echo 'export JAVA_HOME=/usr/local/jdk1.8.0_221' >> /etc/profile \
    && echo 'export JRE_HOME=$JAVA_HOME/jre'	 >> /etc/profile \
    && echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile \
    && echo 'export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin'	>> /etc/profile \
    && echo 'source /etc/profile'   >> ~/.bashrc   \
    && source /etc/profile    


