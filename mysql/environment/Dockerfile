FROM mysql:5.7
 
#docker-compose.yml的构建参数
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE

#设置免密登录
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

#创建文件目录
RUN mkdir -p /home/mysql
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

RUN sed -i "s/\$MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g"     /mysql/sql/privileges/privileges.sql
RUN sed -i "s/\$MYSQL_USER/$MYSQL_USER/g"                       /mysql/sql/privileges/privileges.sql 
RUN sed -i "s/\$MYSQL_PASSWORD/$MYSQL_PASSWORD/g"               /mysql/sql/privileges/privileges.sql 
RUN sed -i "s/\$MYSQL_DATABASE/$MYSQL_DATABASE/g"               /mysql/sql/privileges/privileges.sql 

#设置容器启动时执行的命令
CMD ["sh", "/mysql/setup.sh"]