# Jenkins流水线任务拆分



prepare —— build —— deploy —— check



clean_build_env.sh 	——>	build_lib.sh	——>	check_build_result.sh	——> 	build_stibel_prj.sh 	——>	tar_stibel_prj.sh	——>	build文件夹下的构建 ——>  clean_build_env.sh	——>	modify_env_var.sh ——>	run_build_env.sh

构建流程：

1. 首先清理构建公共库前的环境信息，接着进行公共库的构建，然后校验构建的结果。下一步，以公共库为基础，生成应用程序文件包，并拷贝到指定路径。
2. build文件夹下，清理构建前的环境——修改环境变量——以docker-compose运行项目

```
.
├── build_lib.sh	———— 构建公共库，例如StiBel_20220225.tar.gz
├── build_stibel_prj.sh  ———— 以公共库为基础，生成应用程序文件包，例如StiBel_Prj_20220225.tar.gz
├── check_build_result.sh	———— 校验公共库的example执行结果:输出 pass.log和fail.log
├── clean_build_env.sh		———— 清理构建公共库前的环境信息，包括容器和路径
├── common.sh				———— 脚本公共方法
├── run_stibel_prj.sh
└── tar_stibel_prj.sh		———— 拷贝StiBel_Prj_20220225.tar.gz和libstdc++.so.6.0.26到当前路径
```

build文件夹里的内容

```
.
├── clean_build_env.sh
├── common.sh
├── data
│   ├── mysql
│   │   └── data
│   │       └── gitkeep
│   ├── nginx
│   │   └── html
│   │       ├── gitkeep
│   │       └── web.tar.gz
│   └── webserver
│       └── data
│           └── gitkeep
├── docker-compose.yml
├── environment
│   ├── mysql
│   │   ├── conf
│   │   │   └── my.cnf
│   │   ├── Dockerfile
│   │   ├── setup.sh
│   │   └── sql
│   │       ├── docker_mysql
│   │       │   ├── create_table.sql
│   │       │   ├── init_data.sql
│   │       │   └── update_data.sql
│   │       ├── privileges
│   │       │   └── privileges.sql
│   │       └── student
│   │           ├── create_table.sql
│   │           ├── init_data.sql
│   │           └── update_data.sql
│   ├── nginx
│   │   ├── conf
│   │   │   └── nginx.conf
│   │   └── conf.d
│   │       └── default.conf
│   └── webserver
│       ├── Dockerfile
│       └── mysql.yml
├── modify_env_var.sh
└── run_build_env.sh
```



- [ ] 流水线的构建还需要加入脚本执行失败的校验，或者去校验生成物是否存在
- [ ] 下一步，整理脚本的内容，提取一些公共方法，使得逻辑清晰整洁
- [ ] 分多个进程来处理，解耦先参考其他项目，分redis进程，mysql进程
- [x] Docker容器后台运行,就必须有一个前台进程,因此 在webserver的dockerfile的CMD里加入tail -f /dev/null

