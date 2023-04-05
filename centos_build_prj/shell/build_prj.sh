#!/bin/bash
source ./common.sh

#打印环境变量
function printEnvInfo() {
  logDebug "printEnvInfo begin"

  if [ ! -d ${code_download_path} ]; then
    mkdir -p ${code_download_path}
  fi

  logInfo "container_list:[${container_list}]"
  logInfo "image_list:[${image_list}]"
  logInfo "code_download_path:[${code_download_path}]"
  logInfo "code_list:[${code_list}]"

  logDebug "printEnvInfo end"
}

#下载代码
function downloadCode() {
  logDebug "downloadCode begin"

  cd $code_download_path

  for code_path in $code_list; do
    logInfo "rm -rf ./${code_path}"
    rm -rf ./${code_path}
  done

  for code_path in $code_list; do
    logInfo "git clone \"git@github.com:klc407073648/${code_path}.git\""
    git clone git@github.com:klc407073648/${code_path}.git
  done

  checkExecResult downloadCode

  logDebug "downloadCode end"
}

function runBuildEnv() {
  logDebug "runBuildEnv begin"

  # 前端构建环境
  logWarn "docker run ${frontend_container_name}"
  docker run -it -d -v ${code_download_path}:${code_download_path} --name \
    ${frontend_container_name} ${frontend_image_name} /bin/bash

  # 后端运行环境
  logWarn "docker run ${java_backend_container_name}"
  docker run -it -d -v ${code_download_path}:${code_download_path} --name \
    ${java_backend_container_name} ${java_backend_image_name} /bin/bash

  # drogon的后端环境，特殊处理，后续整改
  logWarn "docker run ${cpp_backend_container_name}"
  docker run -it -d -p 8093:8093 -v ${code_download_path}:${code_download_path} --name \
    ${cpp_backend_container_name} ${cpp_backend_image_name} /bin/bash

  logDebug "runBuildEnv begin"
}

# 构建前端
function buildFrontendPrj() {
  logDebug "buildFrontendPrj begin"

  for code_path in $code_list; do
    if [ "$code_path"x = "friendFinder"x ]; then
      friendFinderFrontend
    elif [ "$code_path"x = "userCenter"x ]; then
      userCenterFrontend
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      cmdTerminalFrontend
    fi
  done

  logDebug "buildFrontendPrj end"
}

function friendFinderFrontend() {
  logDebug "friendFinderFrontend begin"

  # 修改环境变量信息
  logInfo "friendFinderFrontend modify_env_var"

  cd ${cur_path}
  ./modify_env_var.sh ${code_download_path}/${code_path}/frontend/docker/ nginx.conf
  ./modify_env_var.sh ${code_download_path}/${code_path}/frontend/src/plugins myAxios.ts

  logWarn "friendFinderFrontend build ${code_path} frontend"

  docker exec -i ${frontend_container_name} /bin/sh -c "source /etc/profile &&  \
    cd ${code_download_path}/${code_path}/frontend  \
    && yarn install -y && yarn global add vite && vite build"

  logDebug "friendFinderFrontend end"
}

function userCenterFrontend() {
  logDebug "userCenterFrontend begin"

  # 修改环境变量信息
  logInfo "userCenterFrontend modify_env_var"
  cd ${cur_path}
  ./modify_env_var.sh ${code_download_path}/${code_path}/frontend/docker/ nginx.conf
  ./modify_env_var.sh ${code_download_path}/${code_path}/frontend/src/plugins myAxios.ts

  logWarn "userCenterFrontend build ${code_path} frontend"

  docker exec -i ${frontend_container_name} /bin/sh -c "source /etc/profile &&  \
    cd ${code_download_path}/${code_path}/frontend  \
    && yarn install -y && yarn global add vite && vite build"

  logDebug "userCenterFrontend end"
}

function cmdTerminalFrontend() {
  logDebug "cmdTerminalFrontend begin"

  # 修改环境变量信息
  logInfo "cmdTerminalFrontend modify_env_var"
  cd ${cur_path}
  ./modify_env_var.sh ${code_download_path}/${code_path}/frontend/docker/ nginx.conf
  ./modify_env_var.sh ${code_download_path}/${code_path}/frontend/ vite.config.ts

  logWarn "cmdTerminalFrontend build ${code_path} frontend"

  docker exec -i ${frontend_container_name} /bin/sh -c "source /etc/profile &&  \
    cd ${code_download_path}/${code_path}/frontend  \
    && yarn install -y && yarn global add vite && vite build"

  logDebug "cmdTerminalFrontend end"
}

function buildFrontendImageAndRun() {
  logDebug "buildFrontendImageAndRun begin"

  cd ${code_download_path}/

  for code_path in $code_list; do
    prefix_name=$(echo "${code_path}-frontend" | tr '[A-Z]' '[a-z]')

    cleanContainerAndImage 

    logWarn "docker build -t ${prefix_name}:${image_tar}  ."

    cd ${code_download_path}/${code_path}/frontend
    docker build -t ${prefix_name}:${image_tar} .
    if [ "$code_path"x = "friendFinder"x ]; then
      port=3000 # TODO解析端口地址不能写死
    elif [ "$code_path"x = "userCenter"x ]; then
      port=8086
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      port=8087
    fi

    logWarn "docker run ${prefix_name}_${suf_num}"

    docker run -p ${port}:80 -d --name ${prefix_name}_${suf_num} ${prefix_name}:${image_tar}
  done

  logDebug "buildFrontendImageAndRun end"
}

#构建build_Prj任务 生成jar文件
function buildBackendPrj() {
  logDebug "buildBackendPrj begin"

  # 修改环境变量信息
  for code_path in $code_list; do
    if [ "$code_path"x = "friendFinder"x ]; then
      friendFinderBackend
    elif [ "$code_path"x = "userCenter"x ]; then
      userCenterBackend
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      cmdTerminalBackend
    fi
  done

  logDebug "buildBackendPrj end"
}

function friendFinderBackend() {
  logDebug "friendFinderBackend begin"

  logInfo "friendFinderBackend modify_env_var"

  cd ${cur_path}
  ./modify_env_var.sh ${code_download_path}/${code_path}/backend/src/main/resources application-prod.yml

  logWarn "friendFinderBackend build ${code_path} backend"

  docker exec -i ${java_backend_container_name} /bin/sh -c "source /etc/profile &&  \
  cd ${code_download_path}/${code_path}/backend && mvn package -DskipTests"

  logDebug "friendFinderBackend begin"
}

function userCenterBackend() {
  logDebug "userCenterBackend begin"

  logInfo "userCenterBackend modify_env_var"

  cd ${cur_path}
  ./modify_env_var.sh ${code_download_path}/${code_path}/backend/src/main/resources application-prod.yml

  logWarn "userCenterBackend build ${code_path} backend"

  docker exec -i ${java_backend_container_name} /bin/sh -c "source /etc/profile &&  \
  cd ${code_download_path}/${code_path}/backend && mvn package -DskipTests"

  logDebug "userCenterBackend begin"
}

function cmdTerminalBackend() {
  logDebug "cmdTerminalBackend begin"

  logInfo "cmdTerminalBackend modify_env_var"

  cd ${cur_path}
  ./modify_env_var.sh ${code_download_path}/${code_path}/cpp-backend config-prod.json

  logWarn "cmdTerminalBackend build ${code_path} backend"

  docker exec -i ${java_backend_container_name} /bin/sh -c "source /etc/profile &&  \
  cd ${code_download_path}/${code_path}/cpp-backend/build && chmod 777 *.sh && ./build.sh"

  logDebug "cmdTerminalBackend begin"
}

function buildBackendImageAndRun() {
  logDebug "buildBackendImageAndRun begin"

  cd ${code_download_path}/

  for code_path in $code_list; do
    if [ "$code_path"x = "friendFinder"x ]; then
      buildJavaBackendImageAndRun 8091
    elif [ "$code_path"x = "userCenter"x ]; then
      buildJavaBackendImageAndRun 8092
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      buildCppBackendImageAndRun
    fi
  done

  logDebug "buildBackendImageAndRun end"
}

function buildJavaBackendImageAndRun() {
  logDebug "buildJavaBackendImageAndRun begin"

  local port=$1
  cd ${code_download_path}

  prefix_name=$(echo "${code_path}-backend" | tr '[A-Z]' '[a-z]')

  cleanContainerAndImage 

  logWarn "docker build -t ${prefix_name}:${image_tar}  ."
  cd ${code_download_path}/${code_path}/backend

  # 特殊处理，解决openjdk和jdk的差别，且指定java路径
  sed -i 's/maven:3.5-jdk-8-alpine/docker.io\/klc407073648\/centos_build_jdk_backend:v1.0/' Dockerfile
  sed -i 's/\"java\"/\"\/usr\/local\/jdk1.8.0_221\/bin\/java\"/' Dockerfile
  docker build -t ${prefix_name}:${image_tar} .

  logWarn "docker run ${prefix_name}:${image_tar}  ."
  docker run -p ${port}:8080 -d --name ${prefix_name}_${suf_num} ${prefix_name}:${image_tar}

  logDebug "buildJavaBackendImageAndRun end"
}

function buildCppBackendImageAndRun() {
  logDebug "buildCppBackendImageAndRun begin"

  local port=$1
  cd ${code_download_path}/

  logDebug "buildCppBackendImageAndRun end"
}

function cleanContainerAndImage() {
  logDebug "cleanContainerAndImage begin"

  logInfo "${prefix_name} clean container and image"
  docker stop ${prefix_name}_${suf_num}
  docker rm ${prefix_name}_${suf_num}
  docker rmi ${prefix_name}:${image_tar}

  logDebug "cleanContainerAndImage end"
}

function MAIN() {
  logError "${0}:build_prj begin"
  printEnvInfo
  downloadCode
  runBuildEnv
  buildFrontendPrj
  buildFrontendImageAndRun
  buildBackendPrj
  buildBackendImageAndRun
  logError "${0}:build_prj end"
}

MAIN

if [ $? -ne 0 ]; then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi
