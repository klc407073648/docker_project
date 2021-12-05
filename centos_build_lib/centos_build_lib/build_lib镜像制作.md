# build_lib镜像

## 参考资料


## 制作build_lib的docker镜像

```
[root@VM-0-10-centos centos_build_lib]# tree
|-- build_lib.sh
|-- conf        ——————解决容器内mysql和redis访问问题
|   |-- mysql
|   `-- redis
|-- Dockerfile
`-- package     ————————编译所需版本包
    |-- cmake-3.14.5.tar.gz
    |-- gcc-9.1.0.tar.gz
    `-- scons-3.1.1.zip



整个构建过程，直接执行./build_lib.sh 即可

制作镜像后：
docker run -it centos_build_lib bash
```

## 实践

宿主机拷贝文件
```
[root@master01 new]# docker cp /home/new/build_lib.tar.gz 31d38d5b1b44:/home
[root@master01 new]# docker cp /home/new/myPrj.tar.gz 31d38d5b1b44:/home
```

容器内操作：
```
cd /home/
tar -zxf build_lib.tar.gz

cd ./build_lib
chmod 777 build.sh
./build.sh

cd ..
tar -zxf myPrj.tar.gz
cd ./myPrj
cp ../build_lib/StiBel_20210310.tar.gz  .
chmod 777 buildMyPrj.sh
./buildMyPrj.sh
cd ./deploy/ToolClass/jsoncpp/
./jsoncppTest

```


## 支持poco编译需要安装gcc9.1版本和cmake3.14.5

进一步，为了编译poco，需要支持C++14，所以需要升级GCC版本，以升级到GCC9.1.0为例：

```
1.普通用户中下载gcc的最新源码包：(或在http://mirror.hust.edu.cn/gnu/gcc/gcc-9.1.0/中下载)

wget http://ftp.gnu.org/gnu/gcc/gcc-9.1.0/gcc-9.1.0.tar.gz

2. 解压安装包
tar -xzf gcc-9.1.0.tar.gz

3. 进入目录gcc-9.1.0 
cd gcc-9.1.0

4.运行download_prerequisites脚本
./contrib/download_prerequisites
该脚本文件会帮我们下载、配置、安装依赖库

5. 建立目录，将所有输出放入该目录
mkdir gcc_temp

6. 进入目录
cd gcc_temp

7. 执行以下命令：
../configure -enable-checking=release -enable-languages=c,c++ -disable-multilib

8. 编译（比较耗时，大概2~4小时，编译时注意时间安排）
make  make install

9. 检查验证
执行gcc --version 

10. 更改链接

ln -sf /usr/local/lib64/libstdc++.so.6.0.26 /usr/lib64/libstdc++.so.6
```

## fastcgi程序所需软件nginx,mysql-client

```
1. 安装nginx 
yum install nginx -y

2. 放置资源文件，并修改权限

/usr/share/nginx/ 路径下 与 html同级
注意：修改login.html和register.html 中ip地址

3. 修改nginx配置文件

/etc/nginx/nginx.conf

4. 如何无法访问web，可以先关闭防火墙
systemctl stop firewalld

防火墙开启对应端口
[root@VM-0-10-centos myPrj]# /sbin/iptables -I INPUT -p tcp --dport 8050 -j ACCEPT
[root@VM-0-10-centos myPrj]# /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT


5. docker 容器中 mysql-client安装

(解决mysql.h文件问题)
yum install -y mysql-devel  

rpm -ivh https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm
yum search mysql-community
yum install  -y mysql-community-client.x86_64

参考：https://www.cnblogs.com/lenmom/p/13650843.html
	   
	   
问题：链接不到：/usr/bin/ld: cannot find -lmysqlclient
原因：libmysqlclient.so不在/usr/lib目录下，而是在/usr/lib64/mysql目录下
解决：建一个软连接或者复制到/usr/lib目录下
cp -r /usr/lib64/mysql/* /usr/lib/

6. mysql和redis

需要首先启动 mysql和redis，且支持容器内访问宿主机的服务器
（分多个容器实现mysql nginx redis 待实现，通过脚本实现这整个过程自动化）

7. 启动程序

./lib/3partlib/bin/spawn-fcgi  -a 127.0.0.1 -p 8050 -f ./deploy/fastcgiTEST
```

## 问题记录

```
问题1：
source /etc/profile 后，docker run 进入容器，环境变量未生效
解答1：
在容器实例中 ~/.bashrc 配置文件末尾添加 source /etc/profile，保存退出即可。这样就能够实现重启后自动刷新配置文件，而无需手动操作。

问题2：
postman发送带cookie的http请求
	https://www.cnblogs.com/sweetheartly/p/10510587.html

问题3：保存制作的镜像
[root@master01 ~]# docker commit 191031d243d9 centos_build_lib:v2
sha256:eba75fa42aef8dd2a5558cee5e2571c80a23ecb826960d9d78cb986f6ffcba6c
[root@master01 ~]# cd /home/build_lib/
[root@master01 build_lib]# docker save -o centos_base_v2.tar centos_build_lib:v2


问题3：

docker rm $(docker ps -q -f status=exited)

#编译g++后更新libstdc++.so.6链接
#若不更新链接，运行时可能会发生错误：
#./a.out: /usr/lib/libstdc++.so.6: version `GLIBCXX_3.4.14' not found

#cd /usr/lib64/
#ln -sf /usr/local/lib64/libstdc++.so.6.0.26 /usr/lib64/libstdc++.so.6

```

