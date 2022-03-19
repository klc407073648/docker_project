#!/bin/bash
source ./common.sh

#打印环境变量
function printEnvInfo() 
{
  logDebug "printEnvInfo begin"

  if [ ! -d ${build_lib_code_download_path} ]; then
    mkdir -p ${build_lib_code_download_path}
  fi

  logInfo "build_lib_container_name:[${build_lib_container_name}]"
  logInfo "build_lib_image_name:[${build_lib_image_name}]"
  logInfo "build_lib_code_download_path:[${build_lib_code_download_path}]"
  logInfo "build_lib_code_git_name:[${build_lib_code_git_name}]"
  logInfo "build_lib_code_git_path:[${build_lib_code_git_path}]"

  logDebug "printEnvInfo end"
}

#下载代码
function downloadCode() 
{
    logDebug "downloadCode begin"

    cd $build_lib_code_download_path

    rm -rf ./${build_lib_code_git_name}
    git clone ${build_lib_code_git_path}

    checkExecResult downloadCode

    logDebug "downloadCode end"
}

#构建build_lib任务生成公共库
function buildLib() 
{
    logDebug "buildLib begin"

    cd ${build_lib_code_download_path}/build_lib/

    cd ./build && chmod 777 *.sh && dos2unix *.sh
    docker run -it -d -v ${build_lib_code_download_path}/build_lib:/home/tools/build_lib --name ${build_lib_container_name} ${build_lib_image_name} /bin/bash
    docker exec -i ${build_lib_container_name} /bin/sh -c "source /etc/profile && cd /home/tools/build_lib/build && ./build.sh"
	
    checkExecResult buildLib

    cd ${build_lib_code_download_path}/build_lib/output

    build_tar_name=`ls |grep StiBel |tail -1`

    cp -rf ${build_lib_code_download_path}/build_lib/output/${build_tar_name} ${cur_path} || (logError "cp tar fail" && exit 1)

    logDebug "buildLib end"
}

function MAIN() 
{
  logError "${0}:build_lib begin"
  printEnvInfo
  downloadCode
  buildLib
  logError "${0}:build_lib end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi