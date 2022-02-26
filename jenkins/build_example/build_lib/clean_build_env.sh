#!/bin/bash
source ./common.sh

#全局变量
build_container_list='centos_build_lib_0 stibel_nginx_web_0 stibel_mysql_0 stibel_webserver_0'  

function printEnvInfo() 
{
  logDebug "printEnvInfo begin"

  if [ ! -d ${download_code_path} ]; then
    mkdir -p ${download_code_path}
  fi

  logError "build_container_list:[${build_container_list}]"

  logDebug "printEnvInfo end"
}

function cleanRunContainer() 
{
  logDebug "cleanRunContainer begin"

  sum=0
  for container_name in $build_container_list; do
    cnt=$(docker ps -a | grep $container_name | wc -l)
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

function MAIN() 
{
  logDebug "MAIN begin"
  printEnvInfo
  cleanRunContainer
  logDebug "MAIN end"
}

MAIN
