# fastdfs docker镜像部署

## 镜像参考链接
> 初始镜像链接: https://www.jianshu.com/p/1038b4d95912  

> fastdfs 项目地址：https://github.com/happyfish100/fastdfs/wiki

## 修改配置
根据服务器修改相应配置，修改**environment/**中**tracker.conf,client.conf,storage.conf,mod_fastdfs.conf**的配置，修改内容见fastdfs 项目wiki.
镜像服务器地址默认设置为0.0.0.0

## 启动容器
```
docker-compose up -d
```
## 进入容器
```
docker exec -it fastdfs /bin/bash
```
## 测试上传文件
```
/usr/bin/fdfs_upload_file /etc/fdfs/client.conf  文件名
```
## 访问端口
```
8888
```