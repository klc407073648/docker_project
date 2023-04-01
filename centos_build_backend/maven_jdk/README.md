# centos_build_jdk_backend

## 镜像初始构建

镜像制作初衷：maven:3.5-jdk-8-alpine 镜像去打包后端jar项目时遇到JavaFx的错误：

```
[INFO] Compiling 53 source files to /home/stibel/prj/friendFinder/backend/target/classes
[INFO] -------------------------------------------------------------
[ERROR] COMPILATION ERROR :
[INFO] -------------------------------------------------------------
[ERROR] /home/stibel/prj/friendFinder/backend/src/main/java/com/klc/friendfinder/service/impl/UserServiceImpl.java:[14,19] package javafx.util does not exist
[INFO] 1 error
[INFO] -------------------------------------------------------------
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 6.787 s
[INFO] Finished at: 2023-04-01T10:36:22Z
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile (default-compile) on project friend-finder: Compilation failure
[ERROR] /home/stibel/prj/friendFinder/backend/src/main/java/com/klc/friendfinder/service/impl/UserServiceImpl.java:[14,19] package javafx.util does not exist
```

根据百度定位是OpenJdk和Jdk的差异:


PC:
```
C:\Users\Jason>java -version
java version "1.8.0_301"
Java(TM) SE Runtime Environment (build 1.8.0_301-b09)
Java HotSpot(TM) 64-Bit Server VM (build 25.301-b09, mixed mode)
```

容器：

```
bash-4.4# /usr/bin/java -version
openjdk version "1.8.0_181"
OpenJDK Runtime Environment (IcedTea 3.9.0) (Alpine 8.181.13-r0)
OpenJDK 64-Bit Server VM (build 25.181-b13, mixed mode)
```

## 改用centos镜像，添加maven和jdk解决

```dockerfile
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

COPY ./settings.xml /apache-maven-3.9.1/conf/settings.xml

#source 使得环境变量生效
RUN source /etc/profile

#解决重启配置不生效（source /etc/profile）
RUN echo 'source /etc/profile'	>> ~/.bashrc
```
## 构建过程

```
docker build -f ./Dockerfile -t docker.io/klc407073648/centos_build_jdk_backend:v1.0 .

#push到docker hub,需要事先docker login 登陆账号
docker push docker.io/klc407073648/centos_build_jdk_backend:v1.0
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
## 运行容器，测试构建第三方库

```bash
docker run -it -d -v /home/stibel/prj/:/home/stibel/prj/ --name centos_build_jdk_backend_0 docker.io/klc407073648/centos_build_jdk_backend:v1.0 /bin/bash
docker exec -it centos_build_jdk_backend_0 bash

# 测试构建
cd /home/stibel/prj/userCenter/backend
mvn package -DskipTests
```
