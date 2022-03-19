#!/bin/bash
source ./common.sh

#打印环境变量
function printEnvInfo() 
{
  logDebug "printEnvInfo begin"

  if [ ! -d ${build_web_code_download_path} ]; then
    mkdir -p ${build_web_code_download_path}
  fi

  logInfo "build_web_container_name:[${build_web_container_name}]"
  logInfo "build_web_image_name:[${build_web_image_name}]"
  logInfo "build_web_code_download_path:[${build_web_code_download_path}]"
  logInfo "build_web_code_git_name:[${build_web_code_git_name}]"
  logInfo "build_web_code_git_path:[${build_web_code_git_path}]"

  logDebug "printEnvInfo end"
}

#下载代码
function downloadCode() 
{
  logDebug "downloadCode begin"

  cd $build_web_code_download_path

  rm -rf ./${build_web_code_git_name}
  git clone ${build_web_code_git_path}

  checkExecResult downloadCode

  logDebug "downloadCode end"
}

#构建buildStiBelProject任务生成公共库
function buildStiBelProject() 
{
  logDebug "buildStiBelProject begin"

  cd ${build_web_code_download_path}/${build_web_code_git_name}/

  cd ./DockerBuild && chmod 777 *.sh && dos2unix *.sh
  docker run -it -d -v ${build_web_code_download_path}/${build_web_code_git_name}:/home/tools/${build_web_code_git_name} --name ${build_web_container_name} ${build_web_image_name} /bin/bash
  
  cd ${cur_path}
  build_tar_name=`ls |grep StiBel |tail -1`

  docker cp ./${build_tar_name} ${build_web_container_name}:/home/tools/${build_web_code_git_name}
  docker exec -i ${build_web_container_name} /bin/sh -c "source /etc/profile && cd /home/tools/StiBel/DockerBuild && ./build.sh"

  checkExecResult buildStiBelProject

  logDebug "buildStiBelProject end"
}

function MAIN() 
{
  logError "${0}:build_stibel_prj begin"
  printEnvInfo
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
