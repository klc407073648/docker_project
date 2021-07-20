FROM mysql:5.7
 
#设置免密登录
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

#创建文件目录
RUN mkdir -p /mysql/sql/docker_mysql
RUN mkdir -p /mysql/sql/student
RUN mkdir -p /mysql/sql/privileges
 
#将所需文件放到容器中
COPY setup.sh /mysql/setup.sh

COPY ./sql/docker_mysql/create_table.sql    /mysql/sql/docker_mysql
COPY ./sql/docker_mysql/init_data.sql       /mysql/sql/docker_mysql
COPY ./sql/docker_mysql/update_data.sql     /mysql/sql/docker_mysql

COPY ./sql/student/create_table.sql         /mysql/sql/student
COPY ./sql/student/init_data.sql            /mysql/sql/student
COPY ./sql/student/update_data.sql          /mysql/sql/student

COPY ./sql/privileges/privileges.sql        /mysql/sql/privileges
 
#设置容器启动时执行的命令
CMD ["sh", "/mysql/setup.sh"]