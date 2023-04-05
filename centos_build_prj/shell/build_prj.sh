#!/bin/bash
source ./common.sh
source ./fun/config_file_deal.sh

#打印环境变量
function printEnvInfo() {
  logDebug "[$FUNCNAME] begin"

  if [ ! -d ${code_download_path} ]; then
    mkdir -p ${code_download_path}
  fi

  logInfo "container_list:[${container_list}]"
  logInfo "image_list:[${image_list}]"
  logInfo "code_download_path:[${code_download_path}]"
  logInfo "code_list:[${code_list}]"

  logDebug "[$FUNCNAME] end"
}

function dealConfigFile() {
  logDebug "[$FUNCNAME] begin"

  parseConfigFile

  logDebug "[$FUNCNAME] end"
}

#下载代码
function downloadCode() {
  logDebug "[$FUNCNAME] begin"

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

  logDebug "[$FUNCNAME] end"
}

function runBuildEnv() {
  logDebug "[$FUNCNAME] begin"

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
  docker run -it -d -p ${CMD_TERMINAL_BACKEND_PORT}:${CMD_TERMINAL_BACKEND_PORT} -v ${code_download_path}:${code_download_path} --name \
    ${cpp_backend_container_name} ${cpp_backend_image_name} /bin/bash

  logDebug "[$FUNCNAME] begin"
}

# 构建前端
function buildFrontendPrj() {
  logDebug "[$FUNCNAME] begin"

  for code_path in $code_list; do
    if [ "$code_path"x = "userCenter"x ]; then
      userCenterFrontend
    elif [ "$code_path"x = "friendFinder"x ]; then
      friendFinderFrontend
    elif [ "$code_path"x = "openApi"x ]; then
      openApiFrontend
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      cmdTerminalFrontend
    fi
  done

  logDebug "[$FUNCNAME] end"
}

function userCenterFrontend() {
  logDebug "[$FUNCNAME] begin"

  # 修改环境变量信息
  logInfo "[$FUNCNAME] modify_env_var"
  cd ${cur_path}
  modifyFileVar ${code_download_path}/${code_path}/frontend/docker/ nginx.conf ${code_path}
  modifyFileVar ${code_download_path}/${code_path}/frontend/src/plugins myAxios.ts ${code_path}

  logWarn "userCenterFrontend build ${code_path} frontend"

  docker exec -i ${frontend_container_name} /bin/sh -c "source /etc/profile &&  \
    cd ${code_download_path}/${code_path}/frontend  \
    && yarn install -y && yarn global add vite && vite build"

  logDebug "[$FUNCNAME] end"
}

function friendFinderFrontend() {
  logDebug "[$FUNCNAME] begin"

  # 修改环境变量信息
  logInfo "[$FUNCNAME] modify_env_var"

  cd ${cur_path}
  modifyFileVar ${code_download_path}/${code_path}/frontend/docker/ nginx.conf ${code_path}
  modifyFileVar ${code_download_path}/${code_path}/frontend/src/plugins myAxios.ts ${code_path}

  logWarn "[$FUNCNAME] build ${code_path} frontend"

  docker exec -i ${frontend_container_name} /bin/sh -c "source /etc/profile &&  \
    cd ${code_download_path}/${code_path}/frontend  \
    && yarn install -y && yarn global add vite && vite build"

  logDebug "[$FUNCNAME] end"
}

function openApiFrontend() {
  logDebug "[$FUNCNAME] begin"

  logDebug "[$FUNCNAME] end"
}

function cmdTerminalFrontend() {
  logDebug "[$FUNCNAME] begin"

  # 修改环境变量信息
  logInfo "[$FUNCNAME] modify_env_var"
  cd ${cur_path}
  modifyFileVar ${code_download_path}/${code_path}/frontend/docker/ nginx.conf ${code_path}
  modifyFileVar ${code_download_path}/${code_path}/frontend/ vite.config.ts ${code_path}

  logWarn "[$FUNCNAME] build ${code_path} frontend"

  docker exec -i ${frontend_container_name} /bin/sh -c "source /etc/profile &&  \
    cd ${code_download_path}/${code_path}/frontend  \
    && yarn install -y && yarn global add vite && vite build"

  logDebug "[$FUNCNAME] end"
}

function buildFrontendImageAndRun() {
  logDebug "[$FUNCNAME] begin"

  cd ${code_download_path}

  for code_path in $code_list; do
    prefix_name=$(echo "${code_path}-frontend" | tr '[A-Z]' '[a-z]')

    cleanContainerAndImage

    logWarn "docker build -t ${prefix_name}:${image_tar}  ."

    cd ${code_download_path}/${code_path}/frontend
    docker build -t ${prefix_name}:${image_tar} .

    if [ "$code_path"x = "userCenter"x ]; then
      port=$USERCENTER_FRONTEND_PORT
    elif [ "$code_path"x = "friendFinder"x ]; then
      port=$FRIENDFINDER_FRONTEND_PORT
    elif [ "$code_path"x = "openApi"x ]; then
      port=$OPENAPI_FRONTEND_PORT
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      port=$CMD_TERMINAL_FRONTEND_PORT
    fi

    logWarn "docker run ${prefix_name}_${suf_num}"

    docker run -p ${port}:80 -d --name ${prefix_name}_${suf_num} ${prefix_name}:${image_tar}
  done

  logDebug "[$FUNCNAME] end"
}

#构建build_Prj任务 生成jar文件
function buildBackendPrj() {
  logDebug "[$FUNCNAME] begin"

  # 修改环境变量信息
  for code_path in $code_list; do
    if [ "$code_path"x = "userCenter"x ]; then
      userCenterBackend
    elif [ "$code_path"x = "friendFinder"x ]; then
      friendFinderBackend
    elif [ "$code_path"x = "openApi"x ]; then
      openApiBackend
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      cmdTerminalBackend
    fi
  done

  logDebug "[$FUNCNAME] end"
}

function userCenterBackend() {
  logDebug "[$FUNCNAME] begin"

  logInfo "[$FUNCNAME] modify_env_var"

  cd ${cur_path}
  modifyFileVar ${code_download_path}/${code_path}/backend/src/main/resources application-prod.yml ${code_path}

  logWarn "[$FUNCNAME] build ${code_path} backend"

  docker exec -i ${java_backend_container_name} /bin/sh -c "source /etc/profile &&  \
  cd ${code_download_path}/${code_path}/backend && mvn package -DskipTests"

  logDebug "[$FUNCNAME] begin"
}

function friendFinderBackend() {
  logDebug "[$FUNCNAME] begin"

  logInfo "[$FUNCNAME] modify_env_var"

  cd ${cur_path}
  modifyFileVar ${code_download_path}/${code_path}/backend/src/main/resources application-prod.yml ${code_path}
  modifyFileVar ${code_download_path}/${code_path}/backend/src/main/java/com/klc/friendfinder/controller MsgController.java ${code_path}
  modifyFileVar ${code_download_path}/${code_path}/backend/src/main/java/com/klc/friendfinder/controller TeamController.java ${code_path}
  modifyFileVar ${code_download_path}/${code_path}/backend/src/main/java/com/klc/friendfinder/controller UserController.java ${code_path}

  logWarn "[$FUNCNAME] build ${code_path} backend"

  docker exec -i ${java_backend_container_name} /bin/sh -c "source /etc/profile &&  \
  cd ${code_download_path}/${code_path}/backend && mvn package -DskipTests"

  logDebug "[$FUNCNAME] begin"
}

function openApiBackend() {
  logDebug "[$FUNCNAME] begin"

  logDebug "[$FUNCNAME] begin"
}

function cmdTerminalBackend() {
  logDebug "[$FUNCNAME] begin"

  logInfo "[$FUNCNAME] modify_env_var"

  cd ${cur_path}
  modifyFileVar ${code_download_path}/${code_path}/cpp-backend config-prod.json ${code_path}

  logWarn "[$FUNCNAME] build ${code_path} backend"

  docker exec -i ${java_backend_container_name} /bin/sh -c "source /etc/profile &&  \
  cd ${code_download_path}/${code_path}/cpp-backend/build && chmod 777 *.sh && ./build.sh"

  logDebug "[$FUNCNAME] begin"
}

function buildBackendImageAndRun() {
  logDebug "[$FUNCNAME] begin"

  cd ${code_download_path}

  for code_path in $code_list; do
    if [ "$code_path"x = "userCenter"x ]; then
      buildJavaBackendImageAndRun $USERCENTER_BACKEND_PORT
    elif [ "$code_path"x = "friendFinder"x ]; then
      buildJavaBackendImageAndRun $FRIENDFINDER_BACKEND_PORT
    elif [ "$code_path"x = "openApi"x ]; then
      buildJavaBackendImageAndRun $OPENAPI_BACKEND_PORT
    elif [ "$code_path"x = "cmd-terminal"x ]; then
      buildCppBackendImageAndRun $CMD_TERMINAL_BACKEND_PORT
    fi
  done

  logDebug "[$FUNCNAME] end"
}

function buildJavaBackendImageAndRun() {
  logDebug "[$FUNCNAME] begin"

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
  docker run -p ${port}:${port} -d --name ${prefix_name}_${suf_num} ${prefix_name}:${image_tar}

  logDebug "[$FUNCNAME] end"
}

function buildCppBackendImageAndRun() {
  logDebug "[$FUNCNAME] begin"

  local port=$1
  cd ${code_download_path}

  logDebug "[$FUNCNAME] end"
}

function cleanContainerAndImage() {
  logDebug "[$FUNCNAME] begin"

  logInfo "${prefix_name} clean container and image"

  cnt=$(docker ps -a | grep ${prefix_name}_${suf_num} | wc -l)
  if [ "$cnt"x = "1"x ]; then
    docker stop ${prefix_name}_${suf_num}
    docker rm ${prefix_name}_${suf_num}
    docker rmi ${prefix_name}:${image_tar}
  fi

  logDebug "[$FUNCNAME] end"
}

function MAIN() {
  logError "[$FUNCNAME] ${0}:build_prj begin"
  printEnvInfo
  dealConfigFile
  downloadCode
  runBuildEnv
  buildFrontendPrj
  buildFrontendImageAndRun
  buildBackendPrj
  buildBackendImageAndRun
  logError "[$FUNCNAME] ${0}:build_prj end"
}

MAIN

if [ $? -ne 0 ]; then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi
