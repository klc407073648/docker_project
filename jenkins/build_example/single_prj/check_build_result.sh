#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`
build_container_name='stibel_build_lib_0'

#构建build_lib任务生成公共库
function checkResult() 
{
    logDebug "checkResult begin"

    docker exec -i ${build_container_name} /bin/sh -c "source /etc/profile && cd /home/tools/build_lib/examples/shell && chmod 777 verify_result.sh && dos2unix verify_result.sh && ./verify_result.sh"
	
    docker cp ${build_container_name}:/home/tools/build_lib/examples/shell/pass.log ${cur_path} || (logError "cp pass.log fail" && exit 1)
    docker cp ${build_container_name}:/home/tools/build_lib/examples/shell/fail.log ${cur_path} || (logError "cp fail.log fail" && exit 1)

    docker stop ${build_container_name}
    docker rm ${build_container_name}

    logDebug "checkResult end"
}

function MAIN() 
{
  logDebug "check_build_result.sh MAIN begin"
  checkResult
  logDebug "check_build_result.sh MAIN end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check check_build_result.sh fail"
  exit 1
else
  echo "check check_build_result.sh success"
fi