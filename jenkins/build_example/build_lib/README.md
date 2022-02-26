# Jenkins Pipeline配置build_lib任务


# 从节点配置

## docker安装以及镜像拉取

**从节点机器安装docker**

```
yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
```

**拉取构建所需镜像**

```
docker pull docker.io/klc407073648/centos_build_lib:v3.0
```

## jdk配置

**安装jdk**
```
cd /usr/local/
tar -zxf jdk-8u221-linux-x64.tar.gz
echo 'export JAVA_HOME=/usr/local/jdk1.8.0_221' >> /etc/profile
echo 'export JRE_HOME=$JAVA_HOME/jre'	 >> /etc/profile
echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin'	>> /etc/profile
source /etc/profile
```

**jenkins上配置从节点**
![1](./images/jenkins从节点配置_1.png)

![2](./images/jenkins从节点配置_2.png)


# 配置github的下载key

```bash
[root@VM-0-10-centos klc]# git config --global --list
fatal: unable to read config file '/root/.gitconfig': No such file or directory
[root@VM-0-10-centos klc]# git config --global user.name "stibel"
[root@VM-0-10-centos klc]# git config --global user.email "407073648@qq.com"
[root@VM-0-10-centos klc]# git config --global --list
user.name=stibel
user.email=407073648@qq.com

[root@VM-0-10-centos klc]# ssh-keygen -t rsa -C "407073648@qq.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
/root/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:mBUfLusWspmQNIBQjtVVRBKNoLySDZryhg/fJQyykWM 407073648@qq.com
The key's randomart image is:
+---[RSA 2048]----+
|oo+..o+B= .      |
|.= o. ...+ .     |
|o + o   o o      |
|.* o o + o       |
|@E+ o + S        |
|oO o . * .       |
|+ o o = o        |
| = . o .         |
|  o .            |
+----[SHA256]-----+

[root@VM-0-10-centos klc]# cat /root/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5fGxKe/i1f0mrZm4PGub88eXriwxJVpj5Il0Gb9qbjg/LekX9FLt9iUYjGLhXTKnSOccjjUyW/fg5sPMi0Kv1FlUReMwIA2QyxLJC9uLe5A1gNsW+i4aYwp2smHC0zyPm6mA1VmYDEG/6VqZBohUZKP31mkXC7/TdMTXAzrE30aUAfoN4hwVvcGm5woVSuFoCW7o1pcQhqLKjMUrO2KGzIcuxWlxzEZt+YXNSXbn7rKLnmO2DWT9ljVgAKsCrUbOGXZBNK0oK6K73jiK29U7SyN/8hYLUWOdYQJhHQsPnEcu57zOwCQjrEoMxDZI6VdItYNOcRTzocHF8XHDr94Xf 407073648@qq.com

```

遗留：

[对YAML :: LoadFile的未定义引用](https://cloud.tencent.com/developer/ask/219444)

## 最终构建方案

1. 拷贝当前docker_project\jenkins\build_example\build_lib路径下所有文件到linux一个文件夹下
2. 执行以下脚本

```
[root@VM-0-10-centos ~]# cd /home/klc/test6/
[root@VM-0-10-centos test6]# chmod 777 *.sh
[root@VM-0-10-centos test6]# dos2unix  *.sh
[root@VM-0-10-centos test6]# ./clean_build_env.sh
[root@VM-0-10-centos test6]# ./download_code.sh
[root@VM-0-10-centos test6]# ./run_build_env.sh
```

遗留mysql访问问题:
```
mysql_real_connect(172.25.0.2, 3306, student) error: Host '172.25.0.4' is not allowed to connect to this MySQL server
```

docker rm $(docker ps -a -q)

具体内容
```
[root@VM-0-10-centos ~]# cd /home/klc/test6/
[root@VM-0-10-centos test6]# chmod 777 *.sh
[root@VM-0-10-centos test6]# dos2unix  *.sh
dos2unix: converting file clean_build_env.sh to Unix format ...
dos2unix: converting file common.sh to Unix format ...
dos2unix: converting file download_code.sh to Unix format ...
dos2unix: converting file run_build_env.sh to Unix format ...
[root@VM-0-10-centos test6]# ./clean_build_env.sh
-- build_container_list:[centos_build_lib_0 stibel_nginx_web_0 stibel_mysql_0 stibel_webserver_0] --
centos_build_lib_0
stibel_nginx_web_0
stibel_mysql_0
stibel_webserver_0
8f334cb1ac5e
783479dd376a
8bf50ca47cf5
0cc20aaba393
```

download_code.sh

```
[root@VM-0-10-centos test6]# ./download_code.sh
-- download_code_path:[/home/klc/test6/download] --
-- build_lib_git_path:[git@github.com:klc407073648/build_lib.git] --
-- stibel_git_path:[git@github.com:klc407073648/StiBel.git] --
-- docker_project_git_path:[git@github.com:klc407073648/docker_project.git] --
-- download_code_list:[build_lib StiBel docker_project] --
-- build_lib download begin --
Cloning into 'build_lib'...
remote: Enumerating objects: 508, done.
remote: Counting objects: 100% (508/508), done.
remote: Compressing objects: 100% (364/364), done.
remote: Total 508 (delta 120), reused 479 (delta 93), pack-reused 0
Receiving objects: 100% (508/508), 23.37 MiB | 249.00 KiB/s, done.
Resolving deltas: 100% (120/120), done.
-- build_lib download end --
-- StiBel download begin --
Cloning into 'StiBel'...
remote: Enumerating objects: 893, done.
remote: Counting objects: 100% (893/893), done.
remote: Compressing objects: 100% (678/678), done.
remote: Total 893 (delta 248), reused 799 (delta 157), pack-reused 0
Receiving objects: 100% (893/893), 11.47 MiB | 119.00 KiB/s, done.
Resolving deltas: 100% (248/248), done.
-- StiBel download end --
-- docker_project download begin --
Cloning into 'docker_project'...
remote: Enumerating objects: 197, done.
remote: Counting objects: 100% (197/197), done.
remote: Compressing objects: 100% (151/151), done.
remote: Total 197 (delta 42), reused 174 (delta 22), pack-reused 0
Receiving objects: 100% (197/197), 25.08 MiB | 49.00 KiB/s, done.
Resolving deltas: 100% (42/42), done.
-- docker_project download end --
```

# 待实现的idea

- [ ] 分多个进程来处理，解耦先参考其他项目，分redis进程，mysql进程
