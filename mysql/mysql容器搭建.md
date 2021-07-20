# mysql容器搭建

用于记录mysql容器搭建内容

* ## 参考资料

  * [详解利用Dockerfile构建mysql镜像并实现数据的初始化及权限设置](https://www.cnblogs.com/zknublx/p/9303231.html)

## 搭建过程

源文件

```
[root@VM-0-10-centos build_mysql]# tree
.
|-- Dockerfile      ————Dockerfile源文件
|-- privileges.sql	————权限设置脚本
|-- schema.sql		————建表脚本1
|-- student.sql		————建表脚本2
`-- setup.sh		————容器启动运行脚本
```

**1.Dockerfile详细内容：**

```
FROM mysql:5.7

#设置免密登录
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

#将所需文件放到容器中
COPY setup.sh /mysql/setup.sh
COPY schema.sql /mysql/schema.sql
COPY student.sql /mysql/student.sql
COPY privileges.sql /mysql/privileges.sql

#设置容器启动时执行的命令
CMD ["sh", "/mysql/setup.sh"]
```

**2.容器启动脚本**

```bash
#!/bin/bash
set -e
 
#查看mysql服务的状态，方便调试，这条语句可以删除
echo `service mysql status`
 
echo '1.启动mysql....'
#启动mysql
service mysql start
sleep 3
echo `service mysql status`
 
echo '2.开始导入数据....'
#导入数据
mysql < /mysql/schema.sql
mysql < /mysql/student.sql
echo '3.导入数据完毕....'
 
sleep 3
echo `service mysql status`
 
#重新设置mysql密码
echo '4.开始修改密码....'
mysql < /mysql/privileges.sql
echo '5.修改密码完毕....'
 
#sleep 3
echo `service mysql status`
echo `mysql容器启动完毕,且数据导入成功`
 
tail -f /dev/null
```

这里是先导入数据，然后才是设置用户和权限，是因为mysql容器一开始为免密登录，Dockerfile中有如下设置：`ENV MYSQL_ALLOW_EMPTY_PASSWORD yes`,此时执行导入数据命令不需要登录验证操作，如果是先执行权限操作，那么导入数据则需要登录验证，整个过程就麻烦了许多。

**3、需要导入数据的mysql脚本命令schema.sql,不同的数据库通过不同的建表脚本来写，后期可以考虑create_table,init_table,update_table，分别写建表、初始化数据、升级等。**

docker_mysql数据库：

```sql
-- 创建数据库
create database `docker_mysql` default character set utf8 collate utf8_general_ci;
 
use docker_mysql;
 
-- 建表
DROP TABLE IF EXISTS `user`;
 
CREATE TABLE `user` (
 `id` bigint(20) NOT NULL,
 `created_at` bigint(40) DEFAULT NULL,
 `last_modified` bigint(40) DEFAULT NULL,
 `email` varchar(255) DEFAULT NULL,
 `first_name` varchar(255) DEFAULT NULL,
 `last_name` varchar(255) DEFAULT NULL,
 `username` varchar(255) DEFAULT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
-- 插入数据
INSERT INTO `user` (`id`, `created_at`, `last_modified`, `email`, `first_name`, `last_name`, `username`)
VALUES
  (0,1490257904,1490257904,'john.doe@example.com','John','Doe','user');
```

student数据库：

```sql
-- 创建数据库
create database `student` default character set utf8 collate utf8_general_ci;
 
use student;

-- 建表
DROP TABLE IF EXISTS `student`;

CREATE TABLE `student` (
  `id` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` enum('man','woman') DEFAULT NULL,
  `class` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- 插入数据
INSERT INTO `student` VALUES (1001, 'Jason', 25, 'man', 1);
INSERT INTO `student` VALUES (1002, 'Helen', 25, 'woman', 3);
INSERT INTO `student` VALUES (1003, 'Steve', 27, 'man', 5);
INSERT INTO `student` VALUES (1004, 'Hanna', 25, 'woman', 1);
INSERT INTO `student` VALUES (1005, 'Bob', 26, 'man', 3);
INSERT INTO `student` VALUES (1006, 'John', 28, 'man', 7);
INSERT INTO `student` VALUES (1007, 'Walln', 25, 'woman', 8);

```

**4、mysql权限设置命令privileges.sql，进行分角色权限控制，给不同的用户以不同的权限。**

```sql
use mysql;
select host, user from user;
-- 因为mysql版本是5.7，因此新建用户为如下命令：
create user docker identified by '123456';
-- 将docker_mysql数据库的权限授权给创建的docker用户，密码为123456：
grant all on docker_mysql.* to docker@'%' identified by '123456' with grant option;
-- 将所有数据库的权限授权给root用户，密码为123456：
grant all privileges on *.* to root@'%' identified by "123456";
-- 这一条命令一定要有：
flush privileges;
```

**5、创建镜像,在源文件所在路径下，执行以下命令：**

```bash
docker build -t docker-mysql .
```

**6、启动容器,并将端口映射到本地的3307端口：**

```bash
docker run -d -p 3307:3306 docker-mysql
```

命令行如下：

![docker_run](./images/docker_run.png)

查看容器的日志记录，启动过程与启动脚本setup.sh中所规范的步骤一致，数据导入和权限设置成功：

![docker_logs](./images/docker_logs.png)

**7、验证结果：**

![docker_result](./images/docker_result.png)

## 项目搭建

所需文件:
```
|-- build_mysql.sh
|-- Dockerfile
|-- setup.sh
`-- sql
    |-- docker_mysql
    |   |-- create_table.sql
    |   |-- init_data.sql
    |   `-- update_data.sql
    |-- privileges
    |   `-- privileges.sql
    `-- student
        |-- create_table.sql
        |-- init_data.sql
        `-- update_data.sql

```

制作镜像
```
切到所在文件目录，直接执行./build_mysql.sh
```
