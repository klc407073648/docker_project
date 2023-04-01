FROM centos:7

#安装java和maven
ADD ./package/jdk-8u221-linux-x64.tar.gz /usr/local
ADD ./package/apache-maven-3.9.1-bin.tar.gz /usr/local

#添加环境变量到 /etc/profile
RUN echo 'export JAVA_HOME=/usr/local/jdk1.8.0_221' >> /etc/profile
RUN echo 'export JRE_HOME=$JAVA_HOME/jre'	 >> /etc/profile
RUN echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile
RUN echo 'export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin'	>> /etc/profile

RUN echo 'export MAVEN_HOME=/usr/local/apache-maven-3.9.1' >> /etc/profile
RUN echo 'export PATH=${PATH}:${MAVEN_HOME}/bin'	>> /etc/profile

COPY ./conf/settings.xml /usr/local/apache-maven-3.9.1/conf/settings.xml

#source 使得环境变量生效
RUN source /etc/profile

#解决重启配置不生效（source /etc/profile）
RUN echo 'source /etc/profile'	>> ~/.bashrc