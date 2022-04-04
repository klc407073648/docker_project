# 制作Apollo Go 客户端 的docker镜像

## 参考资料

* [Apollo Go 客户端](https://github.com/apolloconfig/agollo)
* [agollo_demo](https://github.com/zouyx/agollo_demo/blob/master/helloworld/check.go)


## 制作Apollo Go的docker镜像

```
yum install tree

[root@master01 groovy]# tree
.
├── build_go.sh
├── Dockerfile
└── package
    ├── apollo_go.tar.gz
    ├── go1.16.6.linux-amd64.tar.gz
    └── main.go

整个构建过程，直接执行./build_go.sh 即可

```

## 实践

```
[root@iZuf61kbf845xt6tz10abgZ test]# docker run -it -d -p 8083:8083 --name io/klc407073648/centos_build_go:v1.0
6a6d6999034bb47e48e9ee3562b7895760cb8d96d0246b275187d7a58579bf3c
[root@iZuf61kbf845xt6tz10abgZ test]# docker exec -it apollo_go_client bash
[root@6a6d6999034b /]# cd /home/go/prj/
[root@6a6d6999034b prj]# go run main.go
[get all server info: []]
[[get no real server!]]
[syncServerIpList started]
```

## apollo go客户端源码

1. 官网采用 
```
go get -u github.com/apolloconfig/agollo/v4@latest
```

2. go高版本需要使用go install 安装

```
[root@iZuf61kbf845xt6tz10abgZ TarsGo]# go install  github.com/apolloconfig/agollo/v4@latest
go: downloading github.com/apolloconfig/agollo/v4 v4.1.1
go: downloading github.com/spf13/viper v1.7.1
go: downloading github.com/fsnotify/fsnotify v1.4.7
go: downloading github.com/hashicorp/hcl v1.0.0
go: downloading github.com/magiconair/properties v1.8.1
go: downloading github.com/mitchellh/mapstructure v1.1.2
go: downloading github.com/pelletier/go-toml v1.2.0
go: downloading github.com/spf13/afero v1.1.2
go: downloading github.com/spf13/cast v1.3.0
go: downloading github.com/spf13/jwalterweatherman v1.0.0
go: downloading github.com/spf13/pflag v1.0.3
go: downloading github.com/subosito/gotenv v1.2.0
go: downloading gopkg.in/ini.v1 v1.51.0
go: downloading gopkg.in/yaml.v2 v2.2.4
go: downloading golang.org/x/sys v0.0.0-20190624142023-c5567b49c5d0
go: downloading golang.org/x/text v0.3.2
go install: package github.com/apolloconfig/agollo/v4 is not a main package
```

3. 需要手动修改下载的内容去掉文件夹名称中@version的内容

```
github.com/apolloconfig/agollo/v4@v4.1.1/   为 github.com/apolloconfig/agollo/v4
...
```

4. 完成上述过程中，将安装源码打包成 apollo_go.tar.gz