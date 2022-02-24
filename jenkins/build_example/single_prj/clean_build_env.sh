#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`

function cleanBuildEnv() 
{
    logDebug "cleanBuildEnv begin"

    cd ${cur_path}

    rm -rf ./download
    rm -rf ./logs

    logDebug "cleanBuildEnv end"
}

function MAIN() 
{
  logDebug "clean_build_env.sh MAIN begin"
  cleanBuildEnv
  logDebug "clean_build_env.sh MAIN end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check clean_build_env.sh fail"
  exit 1
else
  echo "check clean_build_env.sh success"
fi