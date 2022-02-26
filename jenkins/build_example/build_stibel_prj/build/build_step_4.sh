#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`
build_container_name='stibel_build_web_0'
build_image_name='docker.io/klc407073648/centos_build_lib:v3.0'
code_download_path=${cur_path}/download
code_git_name='StiBel'
code_git_path='git@github.com:klc407073648/StiBel.git'

#打印环境变量
function printEnvInfo() 
{
  logDebug "printEnvInfo begin"

  if [ ! -d ${code_download_path} ]; then
    mkdir -p ${code_download_path}
  fi

  logInfo "build_container_name:[${build_container_name}]"
  logInfo "build_image_name:[${build_image_name}]"
  logInfo "code_download_path:[${code_download_path}]"
  logInfo "code_git_path:[${code_git_path}]"

  logDebug "printEnvInfo end"
}

#清理运行容器
function cleanRunContainer() 
{
  logDebug "cleanRunContainer begin"

  cnt=`docker ps -a | grep $build_container_name | wc -l`

  if [ "$cnt"x = "1"x ]; then
    docker stop $build_container_name
    logDebug "docker stop $build_container_name"
    docker rm $(docker ps -q -f status=exited)
  fi

  logDebug "cleanRunContainer end"
}

#下载代码
function downloadCode() 
{
  logDebug "downloadCode begin"

  cd $code_download_path

  rm -rf ./${code_git_name}
  git clone ${code_git_path}

  checkExecResult downloadCode

  logDebug "downloadCode end"
}

#构建buildStiBelProject任务生成公共库
function buildStiBelProject() 
{
  logDebug "buildStiBelProject begin"

  cd $code_download_path/$code_git_name/

  cd ./DockerBuild && chmod 777 *.sh && dos2unix *.sh
  docker run -it -d -v ${code_download_path}/$code_git_name:/home/tools/$code_git_name --name ${build_container_name} ${build_image_name} /bin/bash
  
  cd ${cur_path}
  build_tar_name=`ls |grep StiBel |tail -1`

  docker cp ./${build_tar_name} ${build_container_name}:/home/tools/$code_git_name
  docker exec -i ${build_container_name} /bin/sh -c "source /etc/profile && cd /home/tools/StiBel/DockerBuild && ./build.sh"

  checkExecResult buildStiBelProject

  logDebug "buildStiBelProject end"
}

function MAIN() 
{
  logError "${0}:build_stibel_prj begin"
  printEnvInfo
  cleanRunContainer
  downloadCode
  buildStiBelProject
  logError "${0}:build_stibel_prj end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi
