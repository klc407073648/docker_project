#!/bin/bash
source ./common.sh

#构建build_lib任务生成公共库
function tarStibelPrj() 
{
    logDebug "tarStibelPrj begin"

    buildTime=`date +"%Y%m%d"`

    docker exec -i ${build_web_container_name} /bin/sh -c "cp /usr/local/lib64/libstdc++.so.6.0.26 /home/tools/StiBel"
    docker exec -i ${build_web_container_name} /bin/sh -c "cd /home/tools/StiBel && tar zcvf StiBel_Prj_${buildTime}.tar.gz ./include ./lib ./logs ./deploy ./conf ./DockerBuild"
  
    cd $cur_path/download/StiBel

    build_tar_name=`ls |grep StiBel_Prj |tail -1`

    cp -rf $cur_path/download/StiBel/${build_tar_name} ${cur_path}/../output || (logError "cp tar fail" && exit 1)
    cp -rf $cur_path/download/StiBel/libstdc++.so.6.0.26 ${cur_path}/../output || (logError "cp libstdc++ fail" && exit 1)

    #docker stop ${build_web_container_name}
    #docker rm ${build_web_container_name}

    logDebug "tarStibelPrj end"
}

function MAIN() 
{
  logError "${0}:tar_stibel_prj begin"
  tarStibelPrj
  logError "${0}:tar_stibel_prj end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi