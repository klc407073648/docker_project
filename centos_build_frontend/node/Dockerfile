FROM centos:7

# 安装nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
RUN yum install -y nodejs

# 全局安装yarn并配置淘宝源
RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN /u  yum install -y yarn
RUN yarn config set registry http://registry.npm.taobao.org/

# 安装vite
#npm install vite -g
#yarn global add vite

# 安装umi
#yarn global add umi