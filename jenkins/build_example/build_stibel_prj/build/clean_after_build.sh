#!/bin/bash
source ./common.sh

function cleanRunContainer() 
{
  logDebug "cleanRunContainer begin"

  sum=0
  for container_name in $build_container_list; do
    cnt=$(docker ps -a | grep $container_name | wc -l)
    if [ "$cnt"x = "1"x ]; then
      sum=`expr $sum + $cnt`
      docker stop $container_name
      logInfo "docker stop $container_name"
    fi
  done

  if [ "$sum"x != "0"x ]; then
    docker rm $(docker ps -q -f status=exited)
  fi

  logDebug "cleanRunContainer end"
}

function MAIN() 
{
  logError "${0}:clean_after_build begin"
  cleanRunContainer
  logError "${0}:clean_after_build end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi