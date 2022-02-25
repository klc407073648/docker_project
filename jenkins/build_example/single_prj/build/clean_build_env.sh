#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`
build_container_list='centos_build_lib_0 stibel_nginx_web_0 stibel_mysql_0 stibel_webserver_0'  
image_name_list='stibel_nginx_web stibel_mysql stibel_webserver'
image_tar='v1.0'

function cleanBuildEnv() 
{
    logDebug "cleanBuildEnv begin"

    cd ${cur_path}

    rm -rf ./download
    rm -rf ./logs

    logDebug "cleanBuildEnv end"
}

function cleanRunContainer() 
{
  logDebug "cleanRunContainer begin"

  sum=0
  for container_name in $build_container_list; do
    cnt=`docker ps -a | grep $container_name | wc -l`
    if [ "$cnt"x = "1"x ]; then
      sum=`expr $sum + $cnt`
      docker stop $container_name
      logDebug "docker stop $container_name"
    fi
  done

  if [ "$sum"x != "0"x ]; then
    docker rm $(docker ps -q -f status=exited)
  fi

  logDebug "cleanRunContainer end"
}

function cleanBuildImage() 
{
  logDebug "cleanBuildImage begin"

  for image_name in $image_name_list; do
    logDebug "${image_name} in"
    cnt=`docker images -a | grep $image_name | wc -l`
    if [ "$cnt"x = "1"x ]; then
      docker rmi ${image_name}:${image_tar}
      logDebug "docker rmi ${image_name}:${image_tar}"
    fi
  done

  logDebug "cleanBuildImage end"
}

function MAIN() 
{
  logDebug "clean_build_env.sh MAIN begin"
  cleanBuildEnv
  cleanRunContainer
  cleanBuildImage
  logDebug "clean_build_env.sh MAIN end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check clean_build_env.sh fail"
  exit 1
else
  echo "check clean_build_env.sh success"
fi