# Jenkins流水线任务拆分



prepare —— build —— deploy —— check



clean_build_env.sh 	——>	build_lib.sh	——>	check_build_result.sh	——> 	build_stibel_prj.sh 	——>	tar_stibel_prj.sh	——>	build文件夹下的构建 ——>  clean_build_env.sh	——>	modify_env_var.sh ——>	run_build_env.sh

## 项目代码

* [项目github路径](https://github.com/klc407073648/docker_project)
* 详细路径：docker_project\jenkins\build_example\build_stibel_prj

## 构建流程

项目目录结构：

* prepare  —— 预处理，清理构建前的环境
* build      —— 构建公共库
* deploy   —— 部署服务
* check    —— 校验，还未实现

以PipeLine的任务来构建，各个任务之间采用串行运行。

# 构建过程

## 预处理

作用：清理构建公共库前的残留路径；下载docker_project代码；拷贝文件；修改权限

PipeLineScript.txt：

```shell
pipeline {
    agent none

    stages {
        stage('prepare_build_env') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test'){
                   sh "./prepare_step_1.sh" 
                }
            }
        }
    }
}
```

## 构建公共库

作用：

1. clean_before_build	           ——  清理构建前的环境：包括路径和运行容器
2. build_lib                                 ——   构建公共库，例如StiBel_20220225.tar.gz
3. check_build_result                ——  校验公共库的example执行结果:输出 pass.log和fail.log
4. build_stibel_prj                      ——  以公共库为基础，生成应用程序文件包，例如StiBel_Prj_20220225.tar.gz
5. tar_stibel_prj                         ——   拷贝StiBel_Prj_20220225.tar.gz和libstdc++.so.6.0.26到output路径
6. clean_after_build                  ——  清理构建后的环境：运行容器

PipeLineScript.txt：

```shell
pipeline {
    agent none

    stages {
        stage('clean_before_build') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/build'){
                   sh "./build_step_1.sh" 
                }
            }
        }
        
        stage('build_lib') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/build'){
                   sh "./build_step_2.sh"
                }
            }
        }

        stage('check_build_result') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/build'){
                   sh "./build_step_3.sh"
                }
            }
        }

        stage('build_stibel_prj') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/build'){
                   sh "./build_step_4.sh"
                }
            }
        }

        stage('tar_stibel_prj') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/build'){
                   sh "./build_step_5.sh"
                }
            }
        }
        
        stage('clean_after_build') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/build'){
                   sh "./build_step_6.sh"
                }
            }
        }
    }
}
```

## 部署服务

作用：

1. clean_build_env                        ————清理构建前的环境
2. modify_env_var                         ————修改环境变量
3. deploy_stibel_prj                       ————以docker-compose运行项目

PipeLineScript.txt：

```shell
pipeline {
    agent none

    stages {
        stage('clean_build_env') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/deploy'){
                   sh "./deploy_step_1.sh" 
                }
            }
        }

        stage('modify_env_var') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/deploy'){
                   sh "./deploy_step_2.sh" 
                }
            }
        }

        stage('deploy_stibel_prj') {
            agent {label 'node1'}
            steps {
                dir('/home/jenkins/test/deploy'){
                   sh "./deploy_step_3.sh" 
                }
            }
        }
    }
}
```



1. 首先清理构建公共库前的环境信息，接着进行公共库的构建，然后校验构建的结果。下一步，以公共库为基础，生成应用程序文件包，并拷贝到指定路径。
2. build文件夹下，清理构建前的环境——修改环境变量——以docker-compose运行项目


- [ ] 流水线的构建还需要加入脚本执行失败的校验，或者去校验生成物是否存在
- [ ] 下一步，整理脚本的内容，提取一些公共方法，使得逻辑清晰整洁
- [ ] 分多个进程来处理，解耦先参考其他项目，分redis进程，mysql进程
- [x] Docker容器后台运行,就必须有一个前台进程,因此 在webserver的dockerfile的CMD里加入tail -f /dev/null

