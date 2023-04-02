#!/bin/bash
source ./common.sh

#打印环境变量
function printEnvInfo() 
{
  logDebug "printEnvInfo begin"

  if [ ! -d ${build_prj_code_download_path} ]; then
    mkdir -p ${build_prj_code_download_path}
  fi

  logInfo "container_name:[${build_prj_backend_container_name}]"
  logInfo "image_name:[${build_prj_backend_image_name}]"
  logInfo "code_download_path:[${build_prj_code_download_path}]"
  logInfo "code_list:[${build_prj_code_list}]"

  logDebug "printEnvInfo end"
}

#下载代码
function downloadCode() 
{
  logDebug "downloadCode begin"

  cd $build_prj_code_download_path

  for code_path in $build_prj_code_list; do
    logInfo "rm -rf ./${code_path}"
    rm -rf ./${code_path}
  done

  for code_path in $build_prj_code_list; do
    logInfo "git clone \"git@github.com:klc407073648/${code_path}.git\""
    git clone git@github.com:klc407073648/${code_path}.git
  done

  checkExecResult downloadCode

  logDebug "downloadCode end"
}

#构建build_Prj任务 生成jar文件
function buildBackendPrj() 
{
  logDebug "buildBackendPrj begin"

  cd ${build_prj_code_download_path}/

  docker run -it -d -v ${build_prj_code_download_path}:${build_prj_code_download_path} --name ${build_prj_backend_container_name} ${build_prj_backend_image_name} /bin/bash

  # 修改环境变量信息
  cd ${cur_path}
  ./modify_env_var.sh ${build_prj_code_download_path}/${code_path}/backend/src/main/resources application-prod.yml

  for code_path in $build_prj_code_list; do
    docker exec -i ${build_prj_backend_container_name} /bin/sh -c "source /etc/profile && cd ${build_prj_code_download_path}/${code_path}/backend && mvn package -DskipTests"
  done

  logDebug "buildBackendPrj end"
}

function buildBackendImageAndRun() 
{
  logDebug "buildBackendImageAndRun begin"

  cd ${build_prj_code_download_path}/

  for code_path in $build_prj_code_list; do
    echo "${code_path}"
    prefix_name=$(echo "${code_path}-backend" | tr '[A-Z]' '[a-z]')
    echo "${prefix_name}"

    #清理环境
    docker stop ${prefix_name}_${suf_fix}
    docker rm ${prefix_name}_${suf_fix}
    docker rmi ${prefix_name}:${image_tar}
    #清理环境

    logInfo "docker build -t ${prefix_name}:${image_tar}  ."
    cd ${build_prj_code_download_path}/${code_path}/backend

    # 特殊处理，解决openjdk和jdk的差别，且指定java路径
    sed -i 's/maven:3.5-jdk-8-alpine/docker.io\/klc407073648\/centos_build_jdk_backend:v1.0/' Dockerfile
    sed -i 's/\"java\"/\"\/usr\/local\/jdk1.8.0_221\/bin\/java\"/' Dockerfile

    docker build -t ${prefix_name}:${image_tar} .
    if [ "$code_path"x = "friendFinder"x ]; then
      port=8091
    elif [ "$code_path"x = "userCenter"x ]; then
      port=8092
    fi

    docker run -p ${port}:8080 -d --name ${prefix_name}_${suf_fix} ${prefix_name}:${image_tar}
  done

  logDebug "buildBackendImageAndRun end"
}

function buildFrontendPrj() 
{
  logDebug "buildFrontendPrj begin"

  cd ${build_prj_code_download_path}/

  docker run -it -d -v ${build_prj_code_download_path}:${build_prj_code_download_path} --name ${build_prj_frontend_container_name} ${build_prj_frontend_image_name} /bin/bash

  # 修改环境变量信息
  cd ${cur_path}
  ./modify_env_var.sh ${build_prj_code_download_path}/${code_path}/frontend/docker/  nginx.conf
  ./modify_env_var.sh ${build_prj_code_download_path}/${code_path}/frontend/src/plugins myAxios.ts

  for code_path in $build_prj_code_list; do
    docker exec -i ${build_prj_frontend_container_name} /bin/sh -c "source /etc/profile && cd ${build_prj_code_download_path}/${code_path}/frontend  \
    && yarn install -y && yarn global add vite && vite build"
  done

  logDebug "buildFrontendPrj end"
}

function buildFrontendImageAndRun() 
{
  logDebug "buildFrontendImageAndRun begin"

  cd ${build_prj_code_download_path}/

  for code_path in $build_prj_code_list; do
    echo "${code_path}"
    prefix_name=$(echo "${code_path}-frontend" | tr '[A-Z]' '[a-z]')
    echo "${prefix_name}"

    #清理环境
    docker stop ${prefix_name}_${suf_fix}
    docker rm ${prefix_name}_${suf_fix}
    docker rmi ${prefix_name}:${image_tar}
    #清理环境

    logInfo "docker build -t ${prefix_name}:${image_tar}  ."
    cd ${build_prj_code_download_path}/${code_path}/frontend

    docker build -t ${prefix_name}:${image_tar} .
    if [ "$code_path"x = "friendFinder"x ]; then
      port=8090
    elif [ "$code_path"x = "userCenter"x ]; then
      port=8091
    fi

    docker run -p ${port}:80 -d --name ${prefix_name}_${suf_fix} ${prefix_name}:${image_tar}
  done

  logDebug "buildFrontendImageAndRun end"
}

function MAIN() 
{
  logError "${0}:build_prj begin"
  printEnvInfo
  downloadCode
  buildFrontendPrj
  buildFrontendImageAndRun
  #buildBackendPrj
  #buildBackendImageAndRun
  logError "${0}:build_prj end"
}

MAIN

if [ $? -ne 0 ]; then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi
