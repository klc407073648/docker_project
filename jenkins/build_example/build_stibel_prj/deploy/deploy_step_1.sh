#!/bin/bash
source ./common.sh

image_tar=''

function getConfigVar() 
{
  logDebug "getConfigVar begin"

  image_tar=`cat $config_file |grep "IMAGE_TAR=" |cut -f2 -d'='`
  
  logInfo "image_tar:[${image_tar}]"

  logDebug "getConfigVar end"
}

function cleanBuildEnv() 
{
    logDebug "cleanBuildEnv begin"

    cd ${cur_path}

    rm -rf ./logs

    logDebug "cleanBuildEnv end"
}

function cleanRunContainer() 
{
  logDebug "cleanRunContainer begin"

  logInfo "deploy_container_list:[${deploy_container_list}]"

  sum=0
  for container_name in $deploy_container_list; do
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

  logInfo "deploy_image_name_list:[${deploy_image_name_list}]"

  for image_name in $deploy_image_name_list; do
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
  logError "${0}:clean_build_env begin"
  getConfigVar
  cleanBuildEnv
  cleanRunContainer
  cleanBuildImage
  logError "${0}:clean_build_env end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi