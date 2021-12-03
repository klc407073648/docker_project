# docker_project各个微服务

目前，已经处理mysql、redis、nginx的docker-compose启动方法：

* common.sh ——————build_docker_project函数来调用


以nginx为例，分为三个文件

```bash
.
|-- build_nginx.sh		———— 构建脚本
|-- docker-compose.yml	———— 编排文件
`-- environment			———— 所需环境文件，其中会包含nginx.env，每次构建的时候会cp ./environment/nginx.env .env,这个.env是docker-compose.yml所需，用于导入环境变量
    |-- conf
    |   `-- nginx.conf
    |-- conf.d
    |   `-- default.conf
    |-- html
    |   `-- web.tar.gz
    `-- nginx.env

```

注意事项：

* <font color='red'>**动态改变的文件，最好通过挂载方式实现**</font>，便于在宿主机上动态修改文件，而不是每次cp到容器中。同时，<font color='red'>**注意控制权限**</font>，例如ro不允许容器内进程修改文件。

```yml
volumes:
      - ./environment/html:/usr/share/nginx/html:ro
```

