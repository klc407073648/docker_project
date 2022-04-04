#基础镜像
FROM centos:centos7

#创建go工程路径
RUN mkdir -p /home/go/prj

#安装工具
RUN yum -y install zip unzip

#安装go和添加apollo go客户端代码
ADD ./package/go1.16.6.linux-amd64.tar.gz /usr/local
ADD ./package/apollo_go.tar.gz /home/go/prj

# 拷贝测试代码
COPY ./package/main.go /home/go/prj

# 设置环境变量到
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile \
    && echo 'export GOPATH=/home/go/prj'  >> /etc/profile \
    && echo 'go env -w GO111MODULE=auto'  >> /etc/profile \
    && echo 'go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/' >> /etc/profile \
    && echo 'source /etc/profile'  >> ~/.bashrc \
    && source /etc/profile