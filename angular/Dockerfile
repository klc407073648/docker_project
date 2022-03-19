FROM nginx

#将所需文件放到容器中
COPY ./nginx/conf/nginx.conf                        /etc/nginx/nginx.conf
COPY ./nginx/conf.d/default.conf                    /etc/nginx/conf.d/default.conf
ADD ./angularPrj/dist/routerapp/routerapp.tar.gz    /usr/share/nginx/html

#设置容器启动时执行的命令
#CMD ["sh", "/mysql/setup.sh"]

