# jenkins环境搭建

## 关注点


问题:运行jenkins容器报touch: cannot touch ‘/var/jenkins_home/copy_reference_file.log’: Permission denied
```
docker-compose进行本地数据卷映射(- ./data/:/var/jenkins_home)，而容器jenkins user的uid为1000，需要执行
chown -R 1000:1000 ${cur_path}/data
```

参考Jenkins.md
密码klc123456