#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`
build_container_name='stibel_build_web_0'

#构建build_lib任务生成公共库
function tarStibelPrj() 
{
    logDebug "tarStibelPrj begin"

    buildTime=`date +"%Y%m%d"`

    docker exec -i ${build_container_name} /bin/sh -c "cp /usr/local/lib64/libstdc++.so.6.0.26 /home/tools/StiBel"
    docker exec -i ${build_container_name} /bin/sh -c "cd /home/tools/StiBel && tar zcvf StiBel_Prj_${buildTime}.tar.gz ./include ./lib ./logs ./deploy ./conf ./DockerBuild"
  
    cd $cur_path/download/StiBel

    build_tar_name=`ls |grep StiBel_Prj |tail -1`

    cp -rf $cur_path/download/StiBel/${build_tar_name} ${cur_path} || (logError "cp tar fail" && exit 1)
    cp -rf $cur_path/download/StiBel/libstdc++.so.6.0.26 ${cur_path} || (logError "cp libstdc++ fail" && exit 1)

    docker stop ${build_container_name}
    docker rm ${build_container_name}

    logDebug "tarStibelPrj end"
}

function MAIN() 
{
  logDebug "tar_stibel_prj.sh MAIN begin"
  tarStibelPrj
  logDebug "tar_stibel_prj.sh MAIN end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check tar_stibel_prj.sh fail"
  exit 1
else
  echo "check tar_stibel_prj.sh success"
fi