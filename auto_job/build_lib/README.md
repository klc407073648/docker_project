# Jenkins流水线任务 ———— build_lib

# 项目代码

* [build_lib项目](https://github.com/klc407073648/build_lib)

# 整体构建

## 目录结构

项目目录结构：

* shell               —— 构建脚本
* PipeLineScript.txt  —— pipeline 任务的执行脚本

以PipeLine的任务来构建，各个任务之间采用串行运行。

## 脚本说明

.
|-- clean_before_build.sh   —— 构建前清理环境
|-- build_lib.sh            —— 构建公共库文件
|-- check_build_result.sh   —— 校验构建库的demo程序
|-- clean_after_build.sh    —— 清理构建后的环境
|-- common.sh               —— 工具类函数 


将prepare  下的脚本拷贝至 /home/jenkins/test/ 路径下，然后启动jenkins上的prepare任务即可

## 构建过程

将 `build_lib` 文件夹下的内容 放置 虚机上 `/home/klc/auto_job/build_lib/`

1. 准备阶段：

```
cd /home/klc/auto_job/build_lib/
cd ./shell
chmod 777 *.sh
dos2unix *.sh
```

2. 新建pipeline任务，将 `PipeLineScript.txt ` 的内容放置在构建脚本中，保存

3. 点击 `立即构建`