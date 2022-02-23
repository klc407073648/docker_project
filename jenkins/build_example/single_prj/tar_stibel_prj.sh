#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`
build_container_name='stibel_build_web_0'

#构建build_lib任务生成公共库
function tarStibelPrj() {
    logDebug "tarStibelPrj begin"

    buildTime=`date +"%Y%m%d"`

    docker exec -i ${build_container_name} /bin/sh -c "cp /usr/local/lib64/libstdc++.so.6.0.26 /home/tools/StiBel"
    docker exec -i ${build_container_name} /bin/sh -c "cd /home/tools/StiBel && tar zcvf StiBel_Prj_${buildTime}.tar.gz ./include ./lib ./logs ./deploy ./conf"
  
    cd $cur_path/download/StiBel

    build_tar_name=`ls |grep StiBel_Prj |tail -1`

    cp -rf $cur_path/download/StiBel/${build_tar_name} ${cur_path}
    cp -rf $cur_path/download/StiBel/libstdc++.so.6.0.26 ${cur_path}

    #docker stop ${build_container_name}
    #docker rm ${build_container_name}

    logDebug "tarStibelPrj end"
}

function MAIN() {
  logDebug "MAIN begin"
  tarStibelPrj
  logDebug "MAIN end"
}

MAIN